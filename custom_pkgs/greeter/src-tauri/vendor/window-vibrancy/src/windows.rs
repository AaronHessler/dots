// Copyright 2019-2022 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

#![cfg(target_os = "windows")]
#![allow(non_snake_case)]
#![allow(non_camel_case_types)]
#![allow(clippy::upper_case_acronyms)]

use std::ffi::c_void;
pub use windows_sys::Win32::{Foundation::*, Graphics::Dwm::*, System::LibraryLoader::*};

use crate::{Color, Error};

pub fn apply_blur(hwnd: HWND, color: Option<Color>) -> Result<(), Error> {
    if is_win7() {
        let bb = DWM_BLURBEHIND {
            dwFlags: DWM_BB_ENABLE,
            fEnable: true.into(),
            hRgnBlur: std::ptr::null_mut(),
            fTransitionOnMaximized: 0,
        };
        unsafe {
            let _ = DwmEnableBlurBehindWindow(hwnd, &bb);
        }
    } else if is_swca_supported() {
        unsafe {
            SetWindowCompositionAttribute(hwnd, ACCENT_STATE::ACCENT_ENABLE_BLURBEHIND, color);
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
      "\"apply_blur()\" is only available on Windows 7, Windows 10 v1809 or newer and Windows 11.",
    ));
    }
    Ok(())
}

pub fn clear_blur(hwnd: HWND) -> Result<(), Error> {
    if is_win7() {
        let bb = DWM_BLURBEHIND {
            dwFlags: DWM_BB_ENABLE,
            fEnable: false.into(),
            hRgnBlur: std::ptr::null_mut(),
            fTransitionOnMaximized: 0,
        };
        unsafe {
            let _ = DwmEnableBlurBehindWindow(hwnd, &bb);
        }
    } else if is_swca_supported() {
        unsafe {
            SetWindowCompositionAttribute(hwnd, ACCENT_STATE::ACCENT_DISABLED, None);
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
      "\"clear_blur()\" is only available on Windows 7, Windows 10 v1809 or newer and Windows 11.",
    ));
    }
    Ok(())
}

pub fn apply_acrylic(hwnd: HWND, color: Option<Color>) -> Result<(), Error> {
    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_TRANSIENTWINDOW as *const _ as _,
                4,
            );
        }
    } else if is_swca_supported() {
        unsafe {
            SetWindowCompositionAttribute(
                hwnd,
                ACCENT_STATE::ACCENT_ENABLE_ACRYLICBLURBEHIND,
                color,
            );
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"apply_acrylic()\" is only available on Windows 10 v1809 or newer and Windows 11.",
        ));
    }
    Ok(())
}

pub fn clear_acrylic(hwnd: HWND) -> Result<(), Error> {
    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_DISABLE as *const _ as _,
                4,
            );
        }
    } else if is_swca_supported() {
        unsafe {
            SetWindowCompositionAttribute(hwnd, ACCENT_STATE::ACCENT_DISABLED, None);
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"clear_acrylic()\" is only available on Windows 10 v1809 or newer and Windows 11.",
        ));
    }
    Ok(())
}

pub fn apply_mica(hwnd: HWND, dark: Option<bool>) -> Result<(), Error> {
    if let Some(dark) = dark {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_USE_IMMERSIVE_DARK_MODE as _,
                &(dark as u32) as *const _ as _,
                4,
            );
        }
    }

    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_MAINWINDOW as *const _ as _,
                4,
            );
        }
    } else if is_undocumented_mica_supported() {
        unsafe {
            DwmSetWindowAttribute(hwnd, DWMWA_MICA_EFFECT as _, &1 as *const _ as _, 4);
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"apply_mica()\" is only available on Windows 11.",
        ));
    }
    Ok(())
}

pub fn clear_mica(hwnd: HWND) -> Result<(), Error> {
    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_DISABLE as *const _ as _,
                4,
            );
        }
    } else if is_undocumented_mica_supported() {
        unsafe {
            DwmSetWindowAttribute(hwnd, DWMWA_MICA_EFFECT as _, &0 as *const _ as _, 4);
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"clear_mica()\" is only available on Windows 11.",
        ));
    }
    Ok(())
}

pub fn apply_tabbed(hwnd: HWND, dark: Option<bool>) -> Result<(), Error> {
    if let Some(dark) = dark {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_USE_IMMERSIVE_DARK_MODE as _,
                &(dark as u32) as *const _ as _,
                4,
            );
        }
    }

    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_TABBEDWINDOW as *const _ as _,
                4,
            );
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"apply_tabbed()\" is only available on Windows 11.",
        ));
    }
    Ok(())
}

pub fn clear_tabbed(hwnd: HWND) -> Result<(), Error> {
    if is_backdroptype_supported() {
        unsafe {
            DwmSetWindowAttribute(
                hwnd,
                DWMWA_SYSTEMBACKDROP_TYPE as _,
                &DWM_SYSTEMBACKDROP_TYPE::DWMSBT_DISABLE as *const _ as _,
                4,
            );
        }
    } else {
        return Err(Error::UnsupportedPlatformVersion(
            "\"clear_tabbed()\" is only available on Windows 11.",
        ));
    }
    Ok(())
}

fn get_function_impl(library: &str, function: &str) -> Option<FARPROC> {
    assert_eq!(library.chars().last(), Some('\0'));
    assert_eq!(function.chars().last(), Some('\0'));

    let module = unsafe { LoadLibraryA(library.as_ptr()) };
    if module.is_null() {
        return None;
    }
    Some(unsafe { GetProcAddress(module, function.as_ptr()) })
}

macro_rules! get_function {
    ($lib:expr, $func:ident) => {
        get_function_impl(concat!($lib, '\0'), concat!(stringify!($func), '\0'))
            .map(|f| std::mem::transmute::<::windows_sys::Win32::Foundation::FARPROC, $func>(f))
    };
}

#[repr(C)]
struct ACCENT_POLICY {
    AccentState: u32,
    AccentFlags: u32,
    GradientColor: u32,
    AnimationId: u32,
}

type WINDOWCOMPOSITIONATTRIB = u32;

#[repr(C)]
struct WINDOWCOMPOSITIONATTRIBDATA {
    Attrib: WINDOWCOMPOSITIONATTRIB,
    pvData: *mut c_void,
    cbData: usize,
}

#[derive(PartialEq)]
#[repr(C)]
enum ACCENT_STATE {
    ACCENT_DISABLED = 0,
    ACCENT_ENABLE_BLURBEHIND = 3,
    ACCENT_ENABLE_ACRYLICBLURBEHIND = 4,
}

unsafe fn SetWindowCompositionAttribute(
    hwnd: HWND,
    accent_state: ACCENT_STATE,
    color: Option<Color>,
) {
    type SetWindowCompositionAttribute =
        unsafe extern "system" fn(HWND, *mut WINDOWCOMPOSITIONATTRIBDATA) -> BOOL;

    if let Some(set_window_composition_attribute) =
        get_function!("user32.dll", SetWindowCompositionAttribute)
    {
        let mut color = color.unwrap_or_default();

        let is_acrylic = accent_state == ACCENT_STATE::ACCENT_ENABLE_ACRYLICBLURBEHIND;
        if is_acrylic && color.3 == 0 {
            // acrylic doesn't like to have 0 alpha
            color.3 = 1;
        }

        let mut policy = ACCENT_POLICY {
            AccentState: accent_state as _,
            AccentFlags: if is_acrylic { 0 } else { 2 },
            GradientColor: (color.0 as u32)
                | ((color.1 as u32) << 8)
                | ((color.2 as u32) << 16)
                | ((color.3 as u32) << 24),
            AnimationId: 0,
        };

        let mut data = WINDOWCOMPOSITIONATTRIBDATA {
            Attrib: 0x13,
            pvData: &mut policy as *mut _ as _,
            cbData: std::mem::size_of_val(&policy),
        };

        set_window_composition_attribute(hwnd, &mut data as *mut _ as _);
    }
}

const DWMWA_MICA_EFFECT: DWMWINDOWATTRIBUTE = 1029;
const DWMWA_SYSTEMBACKDROP_TYPE: DWMWINDOWATTRIBUTE = 38;

#[allow(unused)]
#[repr(C)]
enum DWM_SYSTEMBACKDROP_TYPE {
    DWMSBT_DISABLE = 1,         // None
    DWMSBT_MAINWINDOW = 2,      // Mica
    DWMSBT_TRANSIENTWINDOW = 3, // Acrylic
    DWMSBT_TABBEDWINDOW = 4,    // Tabbed
}

fn is_win7() -> bool {
    let v = windows_version::OsVersion::current();
    v.major == 6 && v.minor == 1
}

fn is_at_least_build(build: u32) -> bool {
    let v = windows_version::OsVersion::current();
    v.build >= build
}

fn is_swca_supported() -> bool {
    is_at_least_build(17763)
}

fn is_undocumented_mica_supported() -> bool {
    is_at_least_build(22000)
}

fn is_backdroptype_supported() -> bool {
    is_at_least_build(22523)
}
