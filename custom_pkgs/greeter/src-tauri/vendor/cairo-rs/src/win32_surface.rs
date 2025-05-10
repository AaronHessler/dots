// Take a look at the license at the top of the repository in the LICENSE file.

use std::{convert::TryFrom, fmt, ops::Deref};

pub use ffi::winapi;
#[cfg(feature = "use_glib")]
use glib::translate::*;

use crate::{Error, Format, Surface, SurfaceType};

declare_surface!(Win32Surface, SurfaceType::Win32);

impl Win32Surface {
    #[doc(alias = "cairo_win32_surface_create")]
    pub fn create(hdc: winapi::HDC) -> Result<Win32Surface, Error> {
        unsafe { Self::from_raw_full(ffi::cairo_win32_surface_create(hdc)) }
    }

    #[doc(alias = "cairo_win32_surface_create_with_format")]
    pub fn create_with_format(hdc: winapi::HDC, format: Format) -> Result<Win32Surface, Error> {
        unsafe {
            Self::from_raw_full(ffi::cairo_win32_surface_create_with_format(
                hdc,
                format.into(),
            ))
        }
    }

    #[doc(alias = "cairo_win32_surface_create_with_dib")]
    pub fn create_with_dib(format: Format, width: i32, height: i32) -> Result<Win32Surface, Error> {
        unsafe {
            Self::from_raw_full(ffi::cairo_win32_surface_create_with_dib(
                format.into(),
                width,
                height,
            ))
        }
    }

    #[doc(alias = "cairo_win32_surface_create_with_ddb")]
    pub fn create_with_ddb(
        hdc: winapi::HDC,
        format: Format,
        width: i32,
        height: i32,
    ) -> Result<Win32Surface, Error> {
        unsafe {
            Self::from_raw_full(ffi::cairo_win32_surface_create_with_ddb(
                hdc,
                format.into(),
                width,
                height,
            ))
        }
    }

    #[doc(alias = "cairo_win32_printing_surface_create")]
    pub fn printing_surface_create(hdc: winapi::HDC) -> Result<Win32Surface, Error> {
        unsafe { Self::from_raw_full(ffi::cairo_win32_printing_surface_create(hdc)) }
    }
}
