// Copyright 2020-2023 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

//! Unix platform extensions for [`WebContext`](super::WebContext).

use crate::{Error, RequestAsyncResponder};
use gtk::glib::{self, MainContext, ObjectExt};
use http::{header::CONTENT_TYPE, HeaderName, HeaderValue, Request, Response as HttpResponse};
use soup::{MessageHeaders, MessageHeadersType};
use std::{
  borrow::Cow,
  cell::RefCell,
  collections::VecDeque,
  path::{Path, PathBuf},
  rc::Rc,
  sync::{
    atomic::{AtomicBool, Ordering::SeqCst},
    Mutex,
  },
};
use webkit2gtk::{
  ApplicationInfo, AutomationSessionExt, CookiePersistentStorage, DownloadExt, LoadEvent,
  SecurityManagerExt, URIRequest, URIRequestExt, URISchemeRequest, URISchemeRequestExt,
  URISchemeResponse, URISchemeResponseExt, WebContext, WebContextExt as Webkit2gtkContextExt,
  WebView, WebViewExt,
};

#[derive(Debug)]
pub struct WebContextImpl {
  context: WebContext,
  webview_uri_loader: Rc<WebViewUriLoader>,
  automation: bool,
  app_info: Option<ApplicationInfo>,
}

impl WebContextImpl {
  pub fn new(data_directory: Option<&Path>) -> Self {
    use webkit2gtk::{CookieManagerExt, WebsiteDataManager, WebsiteDataManagerExt};
    let mut context_builder = WebContext::builder();
    if let Some(data_directory) = data_directory {
      let data_manager = WebsiteDataManager::builder()
        .base_data_directory(data_directory.to_string_lossy())
        .build();
      if let Some(cookie_manager) = data_manager.cookie_manager() {
        cookie_manager.set_persistent_storage(
          &data_directory.join("cookies").to_string_lossy(),
          CookiePersistentStorage::Text,
        );
      }
      context_builder = context_builder.website_data_manager(&data_manager);
    }
    let context = context_builder.build();

    Self::create_context(context)
  }

  pub fn new_ephemeral() -> Self {
    let context = WebContext::new_ephemeral();

    Self::create_context(context)
  }

  pub fn create_context(context: WebContext) -> Self {
    let automation = false;
    context.set_automation_allowed(automation);

    // e.g. wry 0.9.4
    let app_info = ApplicationInfo::new();
    app_info.set_name(env!("CARGO_PKG_NAME"));
    app_info.set_version(
      env!("CARGO_PKG_VERSION_MAJOR")
        .parse()
        .expect("invalid wry version major"),
      env!("CARGO_PKG_VERSION_MINOR")
        .parse()
        .expect("invalid wry version minor"),
      env!("CARGO_PKG_VERSION_PATCH")
        .parse()
        .expect("invalid wry version patch"),
    );

    Self {
      context,
      automation,
      webview_uri_loader: Rc::default(),
      app_info: Some(app_info),
    }
  }

  pub fn set_allows_automation(&mut self, flag: bool) {
    self.automation = flag;
    self.context.set_automation_allowed(flag);
  }

  pub fn set_web_extensions_directory(&mut self, path: &Path) {
    self
      .context
      .set_web_extensions_directory(&path.to_string_lossy());
  }
}

/// [`WebContext`](super::WebContext) items that only matter on unix.
pub trait WebContextExt {
  /// The GTK [`WebContext`] of all webviews in the context.
  fn context(&self) -> &WebContext;

  /// Register a custom protocol to the web context.
  fn register_uri_scheme<F>(&mut self, name: &str, handler: F) -> crate::Result<()>
  where
    F: Fn(crate::WebViewId, Request<Vec<u8>>, RequestAsyncResponder) + 'static;

  /// Add a [`WebView`] to the queue waiting to be opened.
  ///
  /// See the [`WebViewUriLoader`] for more information.
  fn queue_load_uri(&self, webview: WebView, url: String, headers: Option<http::HeaderMap>);

  /// Flush all queued [`WebView`]s waiting to load a uri.
  ///
  /// See the [`WebViewUriLoader`] for more information.
  fn flush_queue_loader(&self);

  /// If the context allows automation.
  ///
  /// **Note:** `libwebkit2gtk` only allows 1 automation context at a time.
  fn allows_automation(&self) -> bool;

  fn register_automation(&mut self, webview: WebView);

  fn register_download_handler(
    &mut self,
    download_started_callback: Option<Box<dyn FnMut(String, &mut PathBuf) -> bool>>,
    download_completed_callback: Option<Rc<dyn Fn(String, Option<PathBuf>, bool) + 'static>>,
  );
}

impl WebContextExt for super::WebContext {
  fn context(&self) -> &WebContext {
    &self.os.context
  }

  fn register_uri_scheme<F>(&mut self, name: &str, handler: F) -> crate::Result<()>
  where
    F: Fn(crate::WebViewId, Request<Vec<u8>>, RequestAsyncResponder) + 'static,
  {
    // Enable secure context
    self
      .os
      .context
      .security_manager()
      .ok_or(Error::MissingManager)?
      .register_uri_scheme_as_secure(name);

    self.os.context.register_uri_scheme(name, move |request| {
      #[cfg(feature = "tracing")]
      let span = tracing::info_span!(parent: None, "wry::custom_protocol::handle", uri = tracing::field::Empty).entered();

      if let Some(uri) = request.uri() {
        let uri = uri.as_str();

        #[cfg(feature = "tracing")]
        span.record("uri", uri);

        #[allow(unused_mut)]
        let mut http_request = Request::builder().uri(uri).method("GET");

        // Set request http headers
        if let Some(headers) = request.http_headers() {
          if let Some(map) = http_request.headers_mut() {
            headers.foreach(move |k, v| {
              if let Ok(name) = HeaderName::from_bytes(k.as_bytes()) {
                if let Ok(value) = HeaderValue::from_bytes(v.as_bytes()) {
                  map.insert(name, value);
                }
              }
            });
          }
        }

        // Set request http method
        if let Some(method) = request.http_method() {
          http_request = http_request.method(method.as_str());
        }

        let body;
        #[cfg(feature = "linux-body")]
        {
          use gtk::{gdk::prelude::InputStreamExtManual, gio::Cancellable};

          // Set request http body
          let cancellable: Option<&Cancellable> = None;
          body = request
            .http_body()
            .map(|s| {
              const BUFFER_LEN: usize = 1024;
              let mut result = Vec::new();
              let mut buffer = vec![0; BUFFER_LEN];
              while let Ok(count) = s.read(&mut buffer[..], cancellable) {
                if count == BUFFER_LEN {
                  result.append(&mut buffer);
                  buffer.resize(BUFFER_LEN, 0);
                } else {
                  buffer.truncate(count);
                  result.append(&mut buffer);
                  break;
                }
              }
              result
            })
            .unwrap_or_default();
        }
        #[cfg(not(feature = "linux-body"))]
        {
          body = Vec::new();
        }

        let http_request = match http_request.body(body) {
          Ok(req) => req,
          Err(_) => {
            request.finish_error(&mut gtk::glib::Error::new(
              glib::UriError::Failed,
              "Internal server error: could not create request.",
            ));
            return;
          }
        };

        let request_ = MainThreadRequest(request.clone());
        let responder: Box<dyn FnOnce(HttpResponse<Cow<'static, [u8]>>)> =
          Box::new(move |http_response| {
            MainContext::default().invoke(move || {
              let buffer = http_response.body();
              let input = gtk::gio::MemoryInputStream::from_bytes(&gtk::glib::Bytes::from(buffer));
              let content_type = http_response
                .headers()
                .get(CONTENT_TYPE)
                .and_then(|h| h.to_str().ok());

              let response = URISchemeResponse::new(&input, buffer.len() as i64);
              response.set_status(http_response.status().as_u16() as u32, None);
              if let Some(content_type) = content_type {
                response.set_content_type(content_type);
              }

              let headers = MessageHeaders::new(MessageHeadersType::Response);
              for (name, value) in http_response.headers().into_iter() {
                headers.append(name.as_str(), value.to_str().unwrap_or(""));
              }
              response.set_http_headers(headers);
              request_.finish_with_response(&response);
            });

          });

        #[cfg(feature = "tracing")]
        let _span = tracing::info_span!("wry::custom_protocol::call_handler").entered();

        let webview_id = request
          .web_view()
          .and_then(|w| unsafe { w.data::<String>(super::WEBVIEW_ID) })
          .map(|id| unsafe { id.as_ref().clone() })
          .unwrap_or_default();

        handler(&webview_id, http_request, RequestAsyncResponder { responder });
      } else {
        request.finish_error(&mut glib::Error::new(
          glib::FileError::Exist,
          "Could not get uri.",
        ));
      }
    });

    Ok(())
  }

  fn queue_load_uri(&self, webview: WebView, url: String, headers: Option<http::HeaderMap>) {
    self.os.webview_uri_loader.push(webview, url, headers)
  }

  fn flush_queue_loader(&self) {
    self.os.webview_uri_loader.clone().flush()
  }

  fn allows_automation(&self) -> bool {
    self.os.automation
  }

  fn register_automation(&mut self, webview: WebView) {
    if let (true, Some(app_info)) = (self.os.automation, self.os.app_info.take()) {
      self.os.context.connect_automation_started(move |_, auto| {
        let webview = webview.clone();
        auto.set_application_info(&app_info);

        // We do **NOT** support arbitrarily creating new webviews.
        // To support this in the future, we would need a way to specify the
        // default WindowBuilder to use to create the window it will use, and
        // possibly "default" webview attributes. Difficulty comes in for controlling
        // the owned Window that would need to be used.
        //
        // Instead, we just pass the first created webview.
        auto.connect_create_web_view(None, move |_| webview.clone());
      });
    }
  }

  fn register_download_handler(
    &mut self,
    download_started_handler: Option<Box<dyn FnMut(String, &mut PathBuf) -> bool>>,
    download_completed_handler: Option<Rc<dyn Fn(String, Option<PathBuf>, bool) + 'static>>,
  ) {
    let context = &self.os.context;

    let download_started_handler = RefCell::new(download_started_handler);
    let failed = Rc::new(RefCell::new(false));

    context.connect_download_started(move |_context, download| {
      if let Some(uri) = download.request().and_then(|req| req.uri()) {
        let uri = uri.to_string();
        let mut download_location = download
          .destination()
          .map(PathBuf::from)
          .unwrap_or_default();

        if let Some(download_started_handler) = download_started_handler.borrow_mut().as_mut() {
          if download_started_handler(uri, &mut download_location) {
            download.connect_response_notify(move |download| {
              download.set_destination(&download_location.to_string_lossy());
            });
          } else {
            download.cancel();
          }
        }
      }

      download.connect_failed({
        let failed = failed.clone();
        move |_, _error| {
          *failed.borrow_mut() = true;
        }
      });

      if let Some(download_completed_handler) = download_completed_handler.clone() {
        download.connect_finished({
          let failed = failed.clone();
          move |download| {
            if let Some(uri) = download.request().and_then(|req| req.uri()) {
              let failed = *failed.borrow();
              let uri = uri.to_string();
              download_completed_handler(
                uri,
                (!failed)
                  .then(|| download.destination().map(PathBuf::from))
                  .flatten(),
                !failed,
              )
            }
          }
        });
      }
    });
  }
}

struct MainThreadRequest(URISchemeRequest);

impl MainThreadRequest {
  fn finish_with_response(&self, response: &URISchemeResponse) {
    self.0.finish_with_response(response);
  }
}

unsafe impl Send for MainThreadRequest {}
unsafe impl Sync for MainThreadRequest {}

#[derive(Debug)]
struct WebviewUriRequest {
  webview: WebView,
  uri: String,
  headers: Option<http::HeaderMap>,
}

/// Prevents an unknown concurrency bug with loading multiple URIs at the same time on webkit2gtk.
///
/// Using the queue prevents data race issues with loading uris for multiple [`WebView`]s in the
/// same context at the same time. Occasionally, the one of the [`WebView`]s will be clobbered
/// and it's content will be injected into a different [`WebView`].
///
/// Example of `webview-c` clobbering `webview-b` while `webview-a` is okay:
/// ```text
/// webview-a triggers load-change::started
/// URISchemeRequestCallback triggered with webview-a
/// webview-a triggers load-change::committed
/// webview-a triggers load-change::finished
/// webview-b triggers load-change::started
/// webview-c triggers load-change::started
/// URISchemeRequestCallback triggered with webview-c
/// URISchemeRequestCallback triggered with webview-c
/// webview-c triggers load-change::committed
/// webview-c triggers load-change::finished
/// ```
///
/// In that example, `webview-a` will load fine. `webview-b` will remain empty as the uri was
/// never loaded. `webview-c` will contain the content of both `webview-b` and `webview-c`
/// because it was triggered twice even through only started once. The content injected will not
/// be sequential, and often is interjected in the middle of one of the other contents.
///
/// FIXME: We think this may be an underlying concurrency bug in webkit2gtk as the usual ways of
/// fixing threading issues are not working. Ideally, the locks are not needed if we can understand
/// the true cause of the bug.
#[derive(Debug, Default)]
struct WebViewUriLoader {
  lock: AtomicBool,
  queue: Mutex<VecDeque<WebviewUriRequest>>,
}

impl WebViewUriLoader {
  /// Check if the lock is in use.
  fn is_locked(&self) -> bool {
    self.lock.swap(true, SeqCst)
  }

  /// Unlock the lock.
  fn unlock(&self) {
    self.lock.store(false, SeqCst)
  }

  /// Add a [`WebView`] to the queue.
  fn push(&self, webview: WebView, uri: String, headers: Option<http::HeaderMap>) {
    let mut queue = self.queue.lock().expect("poisoned load queue");
    queue.push_back(WebviewUriRequest {
      webview,
      uri,
      headers,
    })
  }

  /// Remove a [`WebView`] from the queue and return it.
  fn pop(&self) -> Option<WebviewUriRequest> {
    let mut queue = self.queue.lock().expect("poisoned load queue");
    queue.pop_front()
  }

  /// Load the next uri to load if the lock is not engaged.
  fn flush(self: Rc<Self>) {
    if !self.is_locked() {
      if let Some(WebviewUriRequest {
        webview,
        uri,
        headers,
      }) = self.pop()
      {
        // we do not need to listen to failed events because those will finish the change event anyways
        webview.connect_load_changed(move |_, event| {
          if let LoadEvent::Finished = event {
            self.unlock();
            self.clone().flush();
          };
        });

        if let Some(headers) = headers {
          let req = URIRequest::builder().uri(&uri).build();

          if let Some(ref mut req_headers) = req.http_headers() {
            for (header, value) in headers.iter() {
              req_headers.append(
                header.to_string().as_str(),
                value.to_str().unwrap_or_default(),
              );
            }
          }

          webview.load_request(&req);
        } else {
          webview.load_uri(&uri);
        }
      } else {
        self.unlock();
      }
    }
  }
}
