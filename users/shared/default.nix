{ pkgs, stateVersion, user, terminaltexteffects, config, ... }:
let
	hypr-conf = import ./hypr/hyprland.nix;
	username = config.home.username;
in
{ 

	home.packages = with pkgs; [
	terminaltexteffects.packages.x86_64-linux.default
		hello
		albert # Replace?
		git # Move

        # Hyprland
		hyprland
		hyprcursor # Check if actually neded + look where it needs to go (scope)!

		# GNOME App Suite
		gnome.eog # Image Viewer (Gnome)
		gnome.nautilus # Files
		gnome-builder # IDE
		papers # Document Viewer
		gnome-usage

		font-manager

		yazi

		# Notifications
		dunst

        # Screenshots
		slurp
		grim
		wl-clipboard

		yt-dlp

	];


	dconf.enable = true;

	programs.kitty = {
		enable = true;
		font.name = "JetBrainsMono";
	};

	programs.zoxide = {
		enable = true;
		enableZshIntegration = true;
	};

	programs.zsh = {
		enable = true;
		enableCompletion = true;
		shellAliases = {
			nixup = "nh os switch";
			homeup = "nh home switch";
			hy = "Hyprland";
			nv = "nvim";
			cd = "z"; # Replace cd with zoxide

			download = "yt-dlp";

			greet = ''
				echo "\n"
				figlet 'Welcome back ${username}' -f cybersmall | tte --no-color --frame-rate 120 unstable
			'';
			
			# typos be gone!
			claer = "clear";
		};
	};

	services.flatpak.enable = true;

	services.xremap = {
		enable = true;
		withWlroots = true;
		config = {
			modmap = [
				{
					name = "System Keybinds";
					remap = {
						CapsLock = 
						{
							held = "leftctrl";
							alone = "esc";
							alone_timeout_millis = 150;
						};
					};
				}
			];
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
			name = "Lucid-Grey-Dark";
		};
		iconTheme = {
			package = pkgs.gnome.adwaita-icon-theme;
			name = "Adwaita";
		};
	};
	home.sessionVariables.GTK_THEME = "Lucid-Grey-Dark";
	home.file.".themes".source = ./gtk;
}
