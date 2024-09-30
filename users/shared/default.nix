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
        kitty

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
	};
}
