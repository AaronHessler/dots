{ pkgs, stateVersion, user, config, ... }: {
	home.packages = with pkgs; [

		obsidian
		hyprpaper
		btop
		overskride
		figlet
		geogebra

		# Gaming
		steam
		modrinth-app

		# Connect
		whatsapp-for-linux
		discord
		ferdium

		# Web
		tor-browser
		chromium

		# Music
		amberol
		spotify
		
		# Design
		# figma-agent # F*ck you so much
		krita

		# Coding
		vscode
		jetbrains.rust-rover
		jetbrains.webstorm

		# Game Development
		godot_4

		# JS Development
		deno # JS Runtime
		pnpm
		nodejs

		# Yubikey
		yubikey-agent
		yubikey-manager

		# darling
		# opendrop

		# Rust Development
		# trunk
		# cargo
		# rustc
		rustup
		# wasm-pack
		gcc
	];


	home.file.".config/nvim" = {
		source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/users/aaron/neovim";
	};



	# Figma
	# systemd.user.services.figma-agent = {
  		# Unit = {
    		# Description = "Figma Agent";
  		# };
  		# Service = {
			# Enable = true;
    		# ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
    		# Restart = "on-failure";
  		# };
  		# Install = {
    		# WantedBy = [ "default.target" ];
  		# };
	# };



	services.hyprpaper = {
		enable = true;
		settings = {
			preload = "${./assets/images/Eclipse.png}";
			wallpaper = ",${./assets/images/Eclipse.png}";
		};
	};

	programs = {
		git = {
			enable = true;
			userName = "Aaron Hessler";
			userEmail = "aaron_hessler@outlook.de";
			extraConfig.init = {
				defaultBranch = "main";	
			};
		};

    	java = {
  			enable = true;
  			package = pkgs.jdk21;
		};


		gh = {
			enable = true;
			settings = { # Don't touch, works, no idea why.
				version = "1";
				prompt = "enabled";
				git_protocol = "https";
			};
		};
	};
}
