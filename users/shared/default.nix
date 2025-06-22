{ pkgs, stateVersion, inputs, user, terminaltexteffects, config, system, quickshell, ... }:
let
	hypr-conf = import ./hypr/hyprland.nix;
in
{ 

	home.packages = with pkgs; [
		terminaltexteffects.packages.${system}.default
		albert # Replace?
		fastfetch

		acpi

        # Hyprland
		hyprland
		hyprcursor # Check if actually neded + look where it needs to go (scope)!

		quickshell.packages.${system}.default

		# GNOME App Suite
		eog # Image Viewer (Gnome)
		nautilus # Files (Gnome)
		sushi # File previewer for nautilus
		gnome-builder # IDE
		papers # Document Viewer
		gnome-usage
		apostrophe


		font-manager

		# Web
		firefox
		inputs.zen-browser.packages."${system}".default

		# CLI Tools
		yazi
		git # Move
		yt-dlp
		tree
		openssl

        # Screenshots
		slurp
		grim
		wl-clipboard

		# Color Picker
		hyprpicker

		# Emoji Picker
		emote

		# Media Control
		playerctl
		pamixer
		swayosd
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
			bye = "shutdown now";
			cya = "systemctl hibernate";
			neofetch = "fastfetch";

			hello = "print \"Hello, Universe!\"";

			"'git gud'" = "echo 'Ha, nice try.'";

			download = "yt-dlp";
			battery = "acpi -i";
			charge = "acpi -i";

			#greet = ''
				#echo "\n"
				#figlet 'Welcome back ${user}' -f cybersmall | tte --no-color --frame-rate 120 unstable
			#'';
			
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
		settings = {
    		python.disabled = true;
  		};
	};

	home.file.".config/fastfetch" = {
		source = "${./fastfetch}";
		recursive = true;
	};

	programs.anyrun = {
		enable = true;
		config = {
			x = { fraction = 0.5; };
      		y = { absolute = 50; };
      		width = {  absolute = 800; };
			hideIcons = false;
			ignoreExclusiveZones = false;
			layer = "overlay";
			hidePluginInfo = false;
			closeOnClick = false;
			showResultsImmediately = false;
			maxEntries = null;

			plugins = [
				inputs.anyrun.packages.${pkgs.system}.applications
				inputs.anyrun.packages.${pkgs.system}.symbols
				inputs.anyrun.packages.${pkgs.system}.rink
			];

		};
		extraCss = ''
			window {
				background-color: rgba(0, 0, 0, 0);
			}
		'';
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
			package = pkgs.adwaita-icon-theme;
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
			size = 32;
		};
		autoEnable = true;
		fonts = {
			sansSerif = {
				package = pkgs.google-fonts;
				name = "Syne";
			};
			monospace = {
				package = pkgs.nerd-fonts.jetbrains-mono;
				name = "JetBrainsMono Nerd Font";
			};
		};
		targets = {
			hyprland.enable = false;
			hyprpaper.enable = false;
		};
	};
}
