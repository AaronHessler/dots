# Release process

Since gtk-rs has multiple crates which have inter-dependencies, it's a bit painful to make a new release. So here are the multiple steps:

 * Merge `master` branch into `crate` branch in every repository (starting with `sys` and ending with `gtk`). (/!\ `cairo-sys` is in `cairo` repository, not `sys` /!\)
 * Update crate version in `Cargo.toml` and the number of its `gtk-rs` dependencies.
 * Open pull requests to `crate` branches to corresponding repositories.
 * Once pull requests have been merged, publish all crates to `crates.io` (using the `cargo publish` command).
 * Merge `pending` branch into `master` in the `gtk-rs/examples` repository (by opening a pull request of course).
 * Update badges version number in the `_data/crates.json` in the `gtk-rs/gtk-rs.github.io` repository.
 * Write a blog post (add the file into `_posts` folder in `gtk-rs.github.io` repository) announcing the new release.
 * Update crate version of the `master` branches on every repository.

NOTE: Pull requests on the `crate` branch aren't build.
