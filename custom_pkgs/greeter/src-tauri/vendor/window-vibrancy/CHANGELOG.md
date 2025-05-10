# Changelog

## \[0.6.0]

- [`03fd627`](https://github.com/tauri-apps/window-vibrancy/commit/03fd627c4bbf740b4931b231095d08e27e838b91) ([#171](https://github.com/tauri-apps/window-vibrancy/pull/171) by [@FabianLars](https://github.com/tauri-apps/window-vibrancy/../../FabianLars)) Update `objc2` to 0.6.0. This raises the msrv to 1.71.

## \[0.5.3]

- [`953f69a`](https://github.com/tauri-apps/window-vibrancy/commit/953f69a1df41a4698ba1f802c097e83b8dd3f7a4) ([#169](https://github.com/tauri-apps/window-vibrancy/pull/169) by [@petersamokhin](https://github.com/tauri-apps/window-vibrancy/../../petersamokhin)) Add `clear_vibrancy` function on macOS.

## \[0.5.2]

- [`3325c24`](https://github.com/tauri-apps/window-vibrancy/commit/3325c24bccbca19f6b93b11adfa0e3b2ab595f73) ([#150](https://github.com/tauri-apps/window-vibrancy/pull/150) by [@madsmtm](https://github.com/tauri-apps/window-vibrancy/../../madsmtm)) Use `objc2` internally, leading to better memory safety.

## \[0.5.1]

- [`9f3d05b`](https://github.com/tauri-apps/window-vibrancy/commit/9f3d05bc3ce6e413e0a08e286490fc937debfe8d) Update `windows-sys` crate to `0.59`

## \[0.5.0]

- [`19cdde3`](https://github.com/tauri-apps/window-vibrancy/commit/19cdde3274a7be7e3f3caf117bc741f5284b6fc4)([#121](https://github.com/tauri-apps/window-vibrancy/pull/121)) **Breaking change** Update `raw-window-handle` crate to 0.6. Now APIs require `HasWindowHandle` trait boundary instead of `HasRawWindowHandle`.

## \[0.4.3]

- [`49587a7`](https://github.com/tauri-apps/window-vibrancy/commit/49587a7b366845048e3945bf525847c01c54d170)([#110](https://github.com/tauri-apps/window-vibrancy/pull/110)) Update `windows-sys` crate to 0.52

## \[0.4.2]

- [`df08bfa`](https://github.com/tauri-apps/window-vibrancy/commit/df08bfad8a5346a0ff00f372834011a162180cb2)([#105](https://github.com/tauri-apps/window-vibrancy/pull/105)) `window_vibrancy::Error` implements [`std::error::Error`](https://doc.rust-lang.org/std/error/trait.Error.html).

## \[0.4.1]

- [`d7520d5`](https://github.com/tauri-apps/window-vibrancy/commit/d7520d5083e4d49cf63ba69566dceade8a8b3712)([#101](https://github.com/tauri-apps/window-vibrancy/pull/101)) On Windows, add `apply_tabbed` and `clear_tabbed`

## \[0.4.0]

- [`a0f4712`](https://github.com/tauri-apps/window-vibrancy/commit/a0f4712db58cb1cb3685383de4d634fd5bda6383)([#90](https://github.com/tauri-apps/window-vibrancy/pull/90)) On Windows, Add option to specify dark for mica effect.

## \[0.3.2]

- Fix `apply_acrylic` on Windows 11 22H2.
  - [d05ef14](https://github.com/tauri-apps/window-vibrancy/commit/d05ef146b94a8ca66e091e62be112a1c57d14563) fix: fix acrylic on windows 11 22523, closes [#45](https://github.com/tauri-apps/window-vibrancy/pull/45) ([#69](https://github.com/tauri-apps/window-vibrancy/pull/69)) on 2022-10-25
  - [aab46e3](https://github.com/tauri-apps/window-vibrancy/commit/aab46e35eaf014d63920999c4e0132baeb55fc50) publish new versions ([#70](https://github.com/tauri-apps/window-vibrancy/pull/70)) on 2022-10-25
  - [d20161f](https://github.com/tauri-apps/window-vibrancy/commit/d20161fc1892908839e4f7d715e16256b2d96900) fix: fix acrylic on win11 22h2 on 2022-11-18

## \[0.3.1]

- Fix acrylic effect on Windows 11 build 22523 and higher
  - [d05ef14](https://github.com/tauri-apps/window-vibrancy/commit/d05ef146b94a8ca66e091e62be112a1c57d14563) fix: fix acrylic on windows 11 22523, closes [#45](https://github.com/tauri-apps/window-vibrancy/pull/45) ([#69](https://github.com/tauri-apps/window-vibrancy/pull/69)) on 2022-10-25

## \[0.3.0]

- Add a 3rd argument to `apply_vibrancy()` to control the vibrancy state, follows window active state by default.
  - [0a566c6](https://github.com/tauri-apps/window-vibrancy/commit/0a566c6cefca0371ce0e19cce8b9c7c7a7ae1f12) feat: (macos) add vibrancy state parameter ([#63](https://github.com/tauri-apps/window-vibrancy/pull/63)) on 2022-09-19
- Add a 4th argument to `apply_vibrancy()` to control the corner radius of the effect view.
  - [bffac24](https://github.com/tauri-apps/window-vibrancy/commit/bffac24a783dfd6c4d147d7bed6d5abc1d126acf) feat: add rounded corner support on MacOS  ([#26](https://github.com/tauri-apps/window-vibrancy/pull/26)) on 2022-09-19

## \[0.2.0]

- Update `raw-window-handle` dependency to 0.5
  - [aef927b](https://github.com/tauri-apps/window-vibrancy/commit/aef927b7378e834c2b14df13de785770c812c8a0) chore(deps): update raw-window-handle to 0.5 on 2022-07-25

## \[0.1.3]

- Fix `apply_acrylic` effect on Windows 11.
  - [7f4e28f](https://github.com/tauri-apps/window-vibrancy/commit/7f4e28fba82bfc70673cc48ca1aabec2356bdccd) fix(acrylic): pass correct `AccentFlags` to `swca` on 2022-04-29
  - [92ef268](https://github.com/tauri-apps/window-vibrancy/commit/92ef268006686fcdc9b8a3dd09d2b71b5140bd7f) chore: add screenshots ([#37](https://github.com/tauri-apps/window-vibrancy/pull/37)) on 2022-05-23
- Add screenshots
  - [92ef268](https://github.com/tauri-apps/window-vibrancy/commit/92ef268006686fcdc9b8a3dd09d2b71b5140bd7f) chore: add screenshots ([#37](https://github.com/tauri-apps/window-vibrancy/pull/37)) on 2022-05-23

## \[0.1.2]

- Update examples and documentation about macOS `NSVisualEffectMaterial`.
  - [e3e2cc7](https://github.com/tauri-apps/window-vibrancy/commit/e3e2cc7323a830305ef84001edfd7a7678d098d7) docs: update examples and macos NSVisualEffectMaterial on 2022-04-15

## \[0.1.1]

- Update crate docs.
  - [2764ca3](https://github.com/tauri-apps/window-vibrancy/commit/2764ca398661b7f4045b39883914f67e299a7fe4) chore: update crate docs on 2022-03-29

## \[0.1.0]

- Initial Release.
  - [78acb98](https://github.com/tauri-apps/window-vibrancy/commit/78acb9800f9a67ff5793de0b45b78225d91e2947) chore(readme): remove installation section on 2022-03-05
