use std::{path::PathBuf, ptr::null_mut};

use objc2::{rc::Retained, runtime::ProtocolObject, DeclaredClass};
use objc2_foundation::{NSData, NSError, NSString, NSURLResponse, NSURL};
use objc2_web_kit::{WKDownload, WKNavigationAction, WKNavigationResponse};

#[cfg(target_os = "ios")]
use crate::wkwebview::ios::WKWebView::WKWebView;
#[cfg(target_os = "macos")]
use objc2_web_kit::WKWebView;

use super::class::{
  wry_download_delegate::WryDownloadDelegate, wry_navigation_delegate::WryNavigationDelegate,
};

// Download action handler
pub(crate) fn navigation_download_action(
  this: &WryNavigationDelegate,
  _webview: &WKWebView,
  _action: &WKNavigationAction,
  download: &WKDownload,
) {
  unsafe {
    if let Some(delegate) = &this.ivars().download_delegate {
      let proto_delegate = ProtocolObject::from_ref(&**delegate);
      download.setDelegate(Some(proto_delegate));
    }
  }
}

// Download response handler
pub(crate) fn navigation_download_response(
  this: &WryNavigationDelegate,
  _webview: &WKWebView,
  _response: &WKNavigationResponse,
  download: &WKDownload,
) {
  unsafe {
    if let Some(delegate) = &this.ivars().download_delegate {
      let proto_delegate = ProtocolObject::from_ref(&**delegate);
      download.setDelegate(Some(proto_delegate));
    }
  }
}

pub(crate) fn download_policy(
  this: &WryDownloadDelegate,
  download: &WKDownload,
  _response: &NSURLResponse,
  suggested_path: &NSString,
  completion_handler: &block2::Block<dyn Fn(*const NSURL)>,
) {
  unsafe {
    let request = download.originalRequest().unwrap();
    let url = request.URL().unwrap().absoluteString().unwrap();
    let mut path = PathBuf::from(suggested_path.to_string());

    let started_fn = &this.ivars().started;
    if let Some(started_fn) = started_fn {
      let mut started_fn = started_fn.borrow_mut();
      match started_fn(url.to_string().to_string(), &mut path) {
        true => {
          let path = NSString::from_str(&path.display().to_string());
          let ns_url = NSURL::fileURLWithPath_isDirectory(&path, false);
          (*completion_handler).call((Retained::as_ptr(&ns_url),))
        }
        false => (*completion_handler).call((null_mut(),)),
      };
    } else {
      #[cfg(feature = "tracing")]
      tracing::warn!("WebView instance is dropped! This navigation handler shouldn't be called.");
      (*completion_handler).call((null_mut(),));
    }
  }
}

pub(crate) fn download_did_finish(this: &WryDownloadDelegate, download: &WKDownload) {
  unsafe {
    let original_request = download.originalRequest().unwrap();
    let url = original_request.URL().unwrap().absoluteString().unwrap();
    if let Some(completed_fn) = this.ivars().completed.clone() {
      completed_fn(url.to_string(), None, true);
    }
  }
}

pub(crate) fn download_did_fail(
  this: &WryDownloadDelegate,
  download: &WKDownload,
  error: &NSError,
  _resume_data: &NSData,
) {
  unsafe {
    #[cfg(debug_assertions)]
    {
      let description = error.localizedDescription().to_string();
      eprintln!("Download failed with error: {}", description);
    }

    let original_request = download.originalRequest().unwrap();
    let url = original_request.URL().unwrap().absoluteString().unwrap();
    if let Some(completed_fn) = this.ivars().completed.clone() {
      completed_fn(url.to_string(), None, false);
    }
  }
}
