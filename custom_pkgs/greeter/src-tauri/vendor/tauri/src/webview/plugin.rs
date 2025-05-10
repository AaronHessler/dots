// Copyright 2019-2024 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

//! The tauri plugin to create and manipulate windows from JS.

use crate::{
  plugin::{Builder, TauriPlugin},
  Runtime,
};

#[cfg(desktop)]
mod desktop_commands {

  use serde::{Deserialize, Serialize};
  use tauri_runtime::dpi::{Position, Size};
  use tauri_utils::config::{BackgroundThrottlingPolicy, WebviewUrl, WindowConfig};

  use super::*;
  use crate::{
    command, sealed::ManagerBase, utils::config::WindowEffectsConfig, webview::Color, AppHandle,
    Webview, WebviewWindowBuilder,
  };

  fn default_true() -> bool {
    true
  }

  #[derive(Debug, PartialEq, Clone, Deserialize)]
  #[serde(rename_all = "camelCase")]
  pub struct WebviewConfig {
    #[serde(default)]
    url: WebviewUrl,
    user_agent: Option<String>,
    drag_drop_enabled: Option<bool>,
    x: f64,
    y: f64,
    width: f64,
    height: f64,
    #[serde(default)]
    transparent: bool,
    #[serde(default = "default_true")]
    focus: bool,
    #[serde(default)]
    accept_first_mouse: bool,
    window_effects: Option<WindowEffectsConfig>,
    #[serde(default)]
    incognito: bool,
    #[serde(default)]
    zoom_hotkeys_enabled: bool,
    #[serde(default)]
    background_throttling: Option<BackgroundThrottlingPolicy>,
    #[serde(default)]
    javascript_disabled: bool,
    #[serde(default = "default_true")]
    allow_link_preview: bool,
    #[serde(default)]
    pub disable_input_accessory_view: bool,
  }

  #[cfg(feature = "unstable")]
  impl<R: Runtime> crate::webview::WebviewBuilder<R> {
    fn from_webview_config(label: String, config: WebviewConfig) -> Self {
      let mut builder = Self::new(label, config.url);
      builder.webview_attributes.user_agent = config.user_agent;
      builder.webview_attributes.drag_drop_handler_enabled =
        config.drag_drop_enabled.unwrap_or(true);
      builder.webview_attributes.transparent = config.transparent;
      builder.webview_attributes.focus = config.focus;
      builder.webview_attributes.accept_first_mouse = config.accept_first_mouse;
      builder.webview_attributes.window_effects = config.window_effects;
      builder.webview_attributes.incognito = config.incognito;
      builder.webview_attributes.zoom_hotkeys_enabled = config.zoom_hotkeys_enabled;
      builder.webview_attributes.background_throttling = config.background_throttling;
      builder.webview_attributes.javascript_disabled = config.javascript_disabled;
      builder.webview_attributes.allow_link_preview = config.allow_link_preview;
      #[cfg(target_os = "ios")]
      if config.disable_input_accessory_view {
        builder
          .webview_attributes
          .input_accessory_view_builder
          .replace(tauri_runtime::InputAccessoryViewBuilder::new(Box::new(
            |_webview| None,
          )));
      }
      builder
    }
  }

  #[derive(Serialize)]
  pub struct WebviewRef {
    window_label: String,
    label: String,
  }

  #[command(root = "crate")]
  pub async fn get_all_webviews<R: Runtime>(app: AppHandle<R>) -> Vec<WebviewRef> {
    app
      .manager()
      .webviews()
      .values()
      .map(|webview| WebviewRef {
        window_label: webview.window_ref().label().into(),
        label: webview.label().into(),
      })
      .collect()
  }

  #[command(root = "crate")]
  pub async fn create_webview_window<R: Runtime>(
    app: AppHandle<R>,
    options: WindowConfig,
  ) -> crate::Result<()> {
    WebviewWindowBuilder::from_config(&app, &options)?.build()?;
    Ok(())
  }
  #[cfg(not(feature = "unstable"))]
  #[command(root = "crate")]
  pub async fn create_webview() -> crate::Result<()> {
    Err(crate::Error::UnstableFeatureNotSupported)
  }

  #[cfg(feature = "unstable")]
  #[command(root = "crate")]
  pub async fn create_webview<R: Runtime>(
    app: AppHandle<R>,
    label: String,
    window_label: String,
    options: WebviewConfig,
  ) -> crate::Result<()> {
    let window = app
      .manager()
      .get_window(&window_label)
      .ok_or(crate::Error::WindowNotFound)?;

    let x = options.x;
    let y = options.y;
    let width = options.width;
    let height = options.height;

    let builder = crate::webview::WebviewBuilder::from_webview_config(label, options);

    window.add_child(
      builder,
      tauri_runtime::dpi::LogicalPosition::new(x, y),
      tauri_runtime::dpi::LogicalSize::new(width, height),
    )?;

    Ok(())
  }

  fn get_webview<R: Runtime>(
    webview: Webview<R>,
    label: Option<String>,
  ) -> crate::Result<Webview<R>> {
    match label {
      Some(l) if !l.is_empty() => webview
        .manager()
        .get_webview(&l)
        .ok_or(crate::Error::WebviewNotFound),
      _ => Ok(webview),
    }
  }

  macro_rules! getter {
    ($cmd: ident, $ret: ty) => {
      getter!($cmd, $cmd, $ret)
    };
    ($fn: ident, $cmd: ident, $ret: ty) => {
      #[command(root = "crate")]
      pub async fn $fn<R: Runtime>(
        webview: Webview<R>,
        label: Option<String>,
      ) -> crate::Result<$ret> {
        get_webview(webview, label)?.$cmd().map_err(Into::into)
      }
    };
  }

  macro_rules! setter {
    ($cmd: ident) => {
      setter!($cmd, $cmd);
    };
    ($fn: ident, $cmd: ident) => {
      #[command(root = "crate")]
      pub async fn $fn<R: Runtime>(
        webview: Webview<R>,
        label: Option<String>,
      ) -> crate::Result<()> {
        get_webview(webview, label)?.$cmd().map_err(Into::into)
      }
    };
    ($fn: ident, $cmd: ident, $input: ty) => {
      #[command(root = "crate")]
      pub async fn $fn<R: Runtime>(
        webview: Webview<R>,
        label: Option<String>,
        value: $input,
      ) -> crate::Result<()> {
        get_webview(webview, label)?.$cmd(value).map_err(Into::into)
      }
    };
  }

  // TODO
  getter!(
    webview_position,
    position,
    tauri_runtime::dpi::PhysicalPosition<i32>
  );
  getter!(webview_size, size, tauri_runtime::dpi::PhysicalSize<u32>);
  //getter!(is_focused, bool);

  setter!(print);
  setter!(webview_close, close);
  setter!(set_webview_size, set_size, Size);
  setter!(set_webview_position, set_position, Position);
  setter!(set_webview_focus, set_focus);
  setter!(webview_hide, hide);
  setter!(webview_show, show);
  setter!(set_webview_zoom, set_zoom, f64);
  setter!(
    set_webview_background_color,
    set_background_color,
    Option<Color>
  );
  setter!(clear_all_browsing_data, clear_all_browsing_data);

  #[command(root = "crate")]
  pub async fn reparent<R: Runtime>(
    webview: crate::Webview<R>,
    label: Option<String>,
    window: String,
  ) -> crate::Result<()> {
    let webview = get_webview(webview, label)?;
    if let Some(window) = webview.manager.get_window(&window) {
      webview.reparent(&window)?;
    }
    Ok(())
  }

  #[cfg(any(debug_assertions, feature = "devtools"))]
  #[command(root = "crate")]
  pub async fn internal_toggle_devtools<R: Runtime>(
    webview: crate::Webview<R>,
    label: Option<String>,
  ) -> crate::Result<()> {
    let webview = get_webview(webview, label)?;
    if webview.is_devtools_open() {
      webview.close_devtools();
    } else {
      webview.open_devtools();
    }
    Ok(())
  }
}

/// Initializes the plugin.
pub fn init<R: Runtime>() -> TauriPlugin<R> {
  #[allow(unused_mut)]
  let mut init_script = String::new();
  // window.print works on Linux/Windows; need to use the API on macOS
  #[cfg(any(target_os = "macos", target_os = "ios"))]
  {
    init_script.push_str(include_str!("./scripts/print.js"));
  }

  #[cfg(any(debug_assertions, feature = "devtools"))]
  {
    use serialize_to_javascript::{default_template, DefaultTemplate, Template};

    #[derive(Template)]
    #[default_template("./scripts/toggle-devtools.js")]
    struct Devtools<'a> {
      os_name: &'a str,
    }

    init_script.push_str(
      &Devtools {
        os_name: std::env::consts::OS,
      }
      .render_default(&Default::default())
      .unwrap()
      .into_string(),
    );
  }

  let mut builder = Builder::new("webview");
  if !init_script.is_empty() {
    builder = builder.js_init_script(init_script);
  }

  builder
    .invoke_handler(
      #[cfg(desktop)]
      crate::generate_handler![
        #![plugin(webview)]
        desktop_commands::create_webview,
        desktop_commands::create_webview_window,
        // getters
        desktop_commands::get_all_webviews,
        desktop_commands::webview_position,
        desktop_commands::webview_size,
        // setters
        desktop_commands::webview_close,
        desktop_commands::set_webview_size,
        desktop_commands::set_webview_position,
        desktop_commands::set_webview_focus,
        desktop_commands::set_webview_background_color,
        desktop_commands::set_webview_zoom,
        desktop_commands::webview_hide,
        desktop_commands::webview_show,
        desktop_commands::print,
        desktop_commands::reparent,
        desktop_commands::clear_all_browsing_data,
        #[cfg(any(debug_assertions, feature = "devtools"))]
        desktop_commands::internal_toggle_devtools,
      ],
      #[cfg(mobile)]
      |invoke| {
        invoke
          .resolver
          .reject("Webview API not available on mobile");
        true
      },
    )
    .build()
}
