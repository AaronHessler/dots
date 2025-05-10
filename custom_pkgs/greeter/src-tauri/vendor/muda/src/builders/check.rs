// Copyright 2022-2022 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

use crate::{accelerator::Accelerator, CheckMenuItem, MenuId};

/// A builder type for [`CheckMenuItem`]
#[derive(Clone, Debug, Default)]
pub struct CheckMenuItemBuilder {
    text: String,
    enabled: bool,
    checked: bool,
    accelerator: Option<Accelerator>,
    id: Option<MenuId>,
}

impl CheckMenuItemBuilder {
    pub fn new() -> Self {
        Default::default()
    }

    /// Set the id this check menu item.
    pub fn id(mut self, id: MenuId) -> Self {
        self.id.replace(id);
        self
    }

    /// Set the text for this check menu item.
    ///
    /// See [`CheckMenuItem::set_text`] for more info.
    pub fn text<S: Into<String>>(mut self, text: S) -> Self {
        self.text = text.into();
        self
    }

    /// Enable or disable this menu item.
    pub fn enabled(mut self, enabled: bool) -> Self {
        self.enabled = enabled;
        self
    }

    /// Check or uncheck this menu item.
    pub fn checked(mut self, checked: bool) -> Self {
        self.checked = checked;
        self
    }

    /// Set this check menu item accelerator.
    pub fn accelerator<A: TryInto<Accelerator>>(
        mut self,
        accelerator: Option<A>,
    ) -> crate::Result<Self>
    where
        crate::Error: From<<A as TryInto<Accelerator>>::Error>,
    {
        self.accelerator = accelerator.map(|a| a.try_into()).transpose()?;
        Ok(self)
    }

    /// Build this check menu item.
    pub fn build(self) -> CheckMenuItem {
        if let Some(id) = self.id {
            CheckMenuItem::with_id(id, self.text, self.enabled, self.checked, self.accelerator)
        } else {
            CheckMenuItem::new(self.text, self.enabled, self.checked, self.accelerator)
        }
    }
}
