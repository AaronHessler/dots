{ pkgs, stateVersion, user, ... }:
let
	hypr-conf = import ./hypr/hyprland.nix;
in
{

	home.packages = with pkgs; [
		hello
		albert # Replace?
		git # Move

        # Hyprland
		hyprland
		hyprcursor # Check if actually neded + look where it needs to go (scope)!

		# GNOME App Suite
		eog # Image Viewer (Gnome)
		nautilus # Files
		gnome-builder # IDE
		decibels # Audio

		# Notifications
		dunst

        # Screenshots
		slurp
		grim
		wl-clipboard
	];

	dconf.enable = true;

	programs.kitty = {
		enable = true;
		font.name = "JetBrainsMono";
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		shellAliases = {
			nixup = "nh os switch";
			homeup = "nh home switch";
		};
	};

	programs.starship = {
		enable = true;
	};

  	wayland.windowManager.hyprland = {
  		enable = true;
		xwayland.enable = true;
		settings = hypr-conf;
  	};

	home = {
		inherit stateVersion;
		username = user;
		homeDirectory = "/home/${user}";

		# Cursor Theme
		pointerCursor = { 
			size = 22;
			gtk.enable = true;
			x11.enable = true;
			name = "Posy_Cursor"; # Shout out to @Posy on youtube. Absolute artist.
			package = pkgs.posy-cursors;
		};
		sessionVariables = {
			HYPRCURSOR_THEME = "Posy_Cursor";
		};

	};

	gtk = {
		enable = true;
		theme = {
			package = pkgs.adw-gtk3;
			name = "adw-gtk3";
		};
		iconTheme = {
			package = pkgs.adwaita-icon-theme;
			name = "Adwaita";
		};
	};
}
