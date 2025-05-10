// Copyright 2022-2022 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

use crate::{accelerator::Accelerator, MenuId, MenuItem};

/// A builder type for [`MenuItem`]
#[derive(Clone, Debug, Default)]
pub struct MenuItemBuilder {
    text: String,
    enabled: bool,
    id: Option<MenuId>,
    accelerator: Option<Accelerator>,
}

impl MenuItemBuilder {
    pub fn new() -> Self {
        Default::default()
    }

    /// Set the id this menu item.
    pub fn id(mut self, id: MenuId) -> Self {
        self.id.replace(id);
        self
    }

    /// Set the text for this menu item.
    ///
    /// See [`MenuItem::set_text`] for more info.
    pub fn text<S: Into<String>>(mut self, text: S) -> Self {
        self.text = text.into();
        self
    }

    /// Enable or disable this menu item.
    pub fn enabled(mut self, enabled: bool) -> Self {
        self.enabled = enabled;
        self
    }

    /// Set this menu item accelerator.
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

    /// Build this menu item.
    pub fn build(self) -> MenuItem {
        if let Some(id) = self.id {
            MenuItem::with_id(id, self.text, self.enabled, self.accelerator)
        } else {
            MenuItem::new(self.text, self.enabled, self.accelerator)
        }
    }
}
