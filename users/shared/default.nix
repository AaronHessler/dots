{ pkgs, stateVersion, user, ... }: {

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

  	#wayland.windowManager.hyprland = {
  		#enable = true;
		#xwayland.enable = true;
  	#};

	home = { # TODO: Move to shared. (Implement shared.)
		inherit stateVersion;
		username = user;
		homeDirectory = "/home/${user}";

		pointerCursor = { 
			size = 22;
			gtk.enable = true;
			x11.enable = true;
			name = "Posy_Cursor"; # Shout out to @Posy on youtube. Absolute artist.
			package = pkgs.posy-cursors;
		};

	};

	gtk = {
		enable = true;
	};
}
