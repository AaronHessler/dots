// Copyright 2022-2022 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

use thiserror::Error;

pub use crate::accelerator::AcceleratorParseError;

/// Errors returned by muda.
#[non_exhaustive]
#[derive(Error, Debug)]
pub enum Error {
    #[error("This menu item is not a child of this `Menu` or `Submenu`")]
    NotAChildOfThisMenu,
    #[cfg(windows)]
    #[error("This menu has not been initialized for this hwnd`")]
    NotInitialized,
    #[cfg(target_os = "linux")]
    #[error("This menu has not been initialized for this gtk window`")]
    NotInitialized,
    #[cfg(windows)]
    #[error("This menu has already been initialized for this hwnd`")]
    AlreadyInitialized,
    #[cfg(target_os = "linux")]
    #[error("This menu has already been initialized for this gtk window`")]
    AlreadyInitialized,
    #[error(transparent)]
    AcceleratorParseError(#[from] AcceleratorParseError),
}

/// Convenient type alias of Result type for muda.
pub type Result<T> = std::result::Result<T, Error>;
