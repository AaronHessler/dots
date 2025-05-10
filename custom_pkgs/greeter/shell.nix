
{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell {
  nativeBuildInputs = [
    pkgs.pkg-config
    pkgs.xdg-utils
  ];
  buildInputs = [
    pkgs.openssl
    pkgs.libsoup_3
    pkgs.libff
    pkgs.zlib
    pkgs.glib
    pkgs.gtk4
    pkgs.gtk3
    pkgs.webkitgtk_4_1
    pkgs.xdg-utils
  ];

  shellHook = ''
    export GDK_BACKEND=x11
    export WEBKIT_DISABLE_DMABUF_RENDERER=1
  '';
}
