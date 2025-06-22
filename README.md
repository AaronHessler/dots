# ApexOS Dotfiles

Welcome to the ApexOS dotfiles repository! This repository contains my personal configuration files, optimized for my workflow.

ApexOS tries to keep everything in the terminal. So don't expect any fancy UIs.
You can expect some fancy TUIs though.

![Banner](./assets/github/banner.png)

## Features

- Color Picker
- Screenshot

## Shell 

ApexOS uses [Nushell](https://www.nushell.sh/)

### Aliases

- `nixup`: Rebuild the system configuration.
- `homeup`: Rebuild the home configuration.
- `download`: Download a video from a website of your choice.
- `hy`: Launch Hyprland.
- `nv`: Launch Neovim.
- `cd`: Use [Zoxide](https://github.com/ajeetdsouza/zoxide)
- `download`: Download a video from a website of your choice.
- `battery` or `battery`: See your current battery percentage.
- `bye`: To power down.
- `cya`: To hibernate.

## Keybinds

- *`hold`* `CAPS` to emulate `CTRL`.
- *`tap`* `CAPS` to emulate `ESC`.
- `SUPER` + `Q` to terminate an application.
- `SUPER` + `E` to open your preferred browser.
- `SUPER` + `T` to open your preffered terminal.
- `SUPER` + `Z` to toggle pin.
- `SUPER` + `B` to toggle split.
- `SUPER` + `SPACE` to open the app launcher.
- `SUPER` + `Arrow Right` to play next media.
- `SUPER` + `Arrow Left` to play previous media.
- `SUPER` + `Arrow Down` to pause media.
- `SHIFT` + `SUPER` + `S` to take a screenshot.
- `SHIFT` + `SUPER` + `C` to pick a color.
- `SUPER` + `[PERIOD]` to pick an emoji.

## Installation

1. Download the minimal [NixOS ISO](https://channels.nixos.org/nixos-24.05/latest-nixos-minimal-x86_64-linux.iso), flash it onto a storage medium, and boot into it.
2. Follow the [nixos install guide](https://nixos.org/manual/nixos/stable/#ch-installation)
   - Set up your partitions.
   - Format the partitions.
   - Mount the partitions.
5. Clone this repository into `/home/[username]/dots`.
6. Update the `FLAKE` environment variable in your config to reflect its location.
7. Add your user.
8. Generate your hardware configuration and append any specific hardware settings to the `hosts` directory.
9. Add your host entry to the `flake.nix` file.
10. Install the system using:
   ```bash
   nixos-install --flake /mnt/home/[username]/dots#[host]
