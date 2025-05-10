// Copyright 2019-2023 Tauri Programme within The Commons Conservancy
// SPDX-License-Identifier: Apache-2.0
// SPDX-License-Identifier: MIT

/**
 * Open files and URLs using their default application.
 *
 * ## Security
 *
 * This API has a scope configuration that forces you to restrict the files and urls to be opened.
 *
 * ### Restricting access to the {@link open | `open`} API
 *
 * On the configuration object, `open: true` means that the {@link open} API can be used with any URL,
 * as the argument is validated with the `^((mailto:\w+)|(tel:\w+)|(https?://\w+)).+` regex.
 * You can change that regex by changing the boolean value to a string, e.g. `open: ^https://github.com/`.
 *
 * @module
 */

import { invoke } from '@tauri-apps/api/core'

/**
 * Opens a url with the system's default app, or the one specified with {@linkcode openWith}.
 *
 * @example
 * ```typescript
 * import { openUrl } from '@tauri-apps/plugin-opener';
 *
 * // opens the given URL on the default browser:
 * await openUrl('https://github.com/tauri-apps/tauri');
 * // opens the given URL using `firefox`:
 * await openUrl('https://github.com/tauri-apps/tauri', 'firefox');
 * ```
 *
 * @param url The URL to open.
 * @param openWith The app to open the URL with. If not specified, defaults to the system default application for the specified url type.
 *
 * @since 2.0.0
 */
export async function openUrl(url: string, openWith?: string): Promise<void> {
  await invoke('plugin:opener|open_url', {
    url,
    with: openWith
  })
}

/**
 * Opens a path with the system's default app, or the one specified with {@linkcode openWith}.
 *
 * @example
 * ```typescript
 * import { openPath } from '@tauri-apps/plugin-opener';
 *
 * // opens a file using the default program:
 * await openPath('/path/to/file');
 * // opens a file using `vlc` command on Windows.
 * await openPath('C:/path/to/file', 'vlc');
 * ```
 *
 * @param path The path to open.
 * @param openWith The app to open the path with. If not specified, defaults to the system default application for the specified path type.
 *
 * @since 2.0.0
 */
export async function openPath(path: string, openWith?: string): Promise<void> {
  await invoke('plugin:opener|open_path', {
    path,
    with: openWith
  })
}

/**
 * Reveal a path with the system's default explorer.
 *
 * #### Platform-specific:
 *
 * - **Android / iOS:** Unsupported.
 *
 * @example
 * ```typescript
 * import { revealItemInDir } from '@tauri-apps/plugin-opener';
 * await revealItemInDir('/path/to/file');
 * ```
 *
 * @param path The path to reveal.
 *
 * @since 2.0.0
 */
export async function revealItemInDir(path: string) {
  return invoke('plugin:opener|reveal_item_in_dir', { path })
}
