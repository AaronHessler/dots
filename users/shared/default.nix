{ pkgs, stateVersion, inputs, user, terminaltexteffects, config, system, ... }:
let
	hypr-conf = import ./hypr/hyprland.nix;
	dots = "/home/aaron/dots";
    spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{ 

    imports = [
        ./mango.nix
    ];

	xdg.enable = true;
	xdg.portal = { # For things like OBS
		enable = true;
		config = {
			hyprland.default = ["hyprland"];
		};
		extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
        ];
	};

	home.file.".config/hypr/xdph.config".source = ./hypr/xdph.conf;

	home.packages = with pkgs; [
		terminaltexteffects.packages.${system}.default

        # Hyprland
		hyprland
		hyprcursor # Check if actually neded + look where it needs to go (scope)!

		# GNOME App Suite
		eog # Image Viewer (Gnome)
		nautilus # Files (Gnome)
		sushi # File previewer for nautilus
        #gnome-builder # IDE
		papers # Document Viewer
		gnome-usage
		apostrophe
        decibels
        amberol

        gsettings-desktop-schemas

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
		fastfetch
		acpi

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

		# Neovim (Language Servers)
        neovim
		typescript-language-server
		typescript
		nixd
		lua-language-server
        vscode-langservers-extracted
        gnumake
        sqls
        yaml-language-server
        pkgs.pyright
        xxd
        tinymist

        ripgrep # telescope
        nodePackages.prettier

	];

    programs.tmux = {
        enable = true;
        extraConfig = ''
            set -g base-index 1

            unbind C-b        
            set -g prefix C-a 
            bind C-a send-prefix 

            set -g status-bg black
            set -g status-fg white

            bind h select-pane -L
            bind j select-pane -D
            bind k select-pane -U
            bind l select-pane -R

            bind s switch-client -T split

            bind -T split h split-window -h -b   # vertical split, pane on the left (back)
            bind -T split j split-window -v -b   # horizontal split, pane below (back)
            bind -T split k split-window -v       # horizontal split, pane above (front)
            bind -T split l split-window -h       # vertical split, pane right (front)

            set -s escape-time 1000
        ''; 
        plugins = [
        ];
    };

    programs.spicetify.enable = false;
    programs.spicetify.enabledExtensions = with spicePkgs.extensions; [
        beautifulLyrics
        hidePodcasts
        shuffle
    ];

	dconf.enable = true;

	programs.kitty = {
		enable = true;
        settings = {
            cursor_trail = 1;
        };
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

            pull = "git pull";
            push = "git push";
            commit = "git commit";
            status = "git status";
            checkout = "git checkout";

			download = "yt-dlp";
			battery = "acpi -i";
			charge = "acpi -i";

            #greet = ''
            #	echo "\n"
                #	figlet 'Welcome back ${user}' -f cybersmall | tte --no-color --frame-rate 120 #unstable
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
		withHypr = true;
		config = {
			modmap = [
				{
					name = "System Keybinds";
					remap = {
						CapsLock = 
						{
                            free_hold = true;
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

	home.file = {
    	".config/nvim"= {
			source = config.lib.file.mkOutOfStoreSymlink "${dots}/users/shared/neovim";
		};
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
                "${pkgs.anyrun}/lib/libapplications.so"
                "${pkgs.anyrun}/lib/libsymbols.so"
			];

		};
		extraCss = ''
			window {
				background-color: rgba(0, 0, 0, 0);
			}
		'';
	};

    programs.swaylock = {
        enable = true;
    };

    services.swaync.enable = true;


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
			neovim.enable = true;
		};
	};
}
