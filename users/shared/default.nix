{ pkgs, stateVersion, user, terminaltexteffects, config, ... }:
let
	hypr-conf = import ./hypr/hyprland.nix;
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

		# Web
		firefox

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
		#font.name = "JetBrainsMono";
	};

	programs.zoxide = {
		enable = true;
		enableNushellIntegration = true;
	};

	programs.nushell = {
		enable = true;
		shellAliases = {
			nixup = "nh os switch";
			homeup = "nh home switch";
			hy = "Hyprland";
			nv = "nvim";
			cd = "z"; # Replace cd with zoxide

			download = "yt-dlp";

			greet = ''
				echo "\n"
				figlet 'Welcome back ${user}' -f cybersmall | tte --no-color --frame-rate 120 unstable
			'';
			
			# typos be gone!
			claer = "clear";
		};
		extraConfig = ''
			$env.config = {
				show_banner: false,
			}
		'';
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
							alone_timeout_millis = 200;
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
		#pointerCursor = { 
			#gtk.enable = true;
			#x11.enable = true;
			#name = "Posy_Cursor"; # Shout out to @Posy on youtube. Absolute artist.
			#package = pkgs.posy-cursors;
		#};
		sessionVariables = {
			#HYPRCURSOR_THEME = "Posy_Cursor";
		};

	};

	gtk = {
		enable = true;
		iconTheme = {
			package = pkgs.gnome.adwaita-icon-theme;
			name = "Adwaita";
		};
	};


	stylix = {
		enable = true;
		base16Scheme = ./style/colors.yaml;
		image = ./assets/Dragonfly.png;
		cursor = {
			package = pkgs.posy-cursors;
			name = "Posy_Cursor";
		};
		autoEnable = true;
		fonts = {
			sansSerif = {
				package = pkgs.google-fonts;
				name = "Syne";
			};
			monospace = {
				package = pkgs.nerdfonts;
				name = "JetBrainsMono Nerd Font";
			};
		};
		targets = {
			hyprland.enable = false;
			hyprpaper.enable = false;
		};
	};
}
