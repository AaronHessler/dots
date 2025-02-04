{ pkgs, unstable-pkgs, stateVersion, user, config, ... }: {
	home.packages = 

		(with pkgs; [
		obsidian
		hyprpaper
		btop
		overskride
		figlet
		geogebra
		open-webui

		# Gaming
		steam
		lutris

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

		# Rust Development
		trunk
		#cargo
		#rust-analyzer
		#rustc
		rustup
		wasm-pack
		gcc

		# Yubikey
		yubikey-agent
		yubikey-manager
		
		# darling
		# opendrop
	])

	++

	(with unstable-pkgs; [
		# figma-agent # F*ck you so much
	]);

	home.file.".config/nvim" = {
		source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dots/users/aaron/neovim";
	};



	# Figma
	systemd.user.services.figma-agent = {
  		Unit = {
    		Description = "Figma Agent";
  		};
  		Service = {
			Enable = true;
    		ExecStart = "figma-agent"; # Use nix-env temporairly #"${unstable-pkgs.figma-agent}/bin/figma-agent";
    		Restart = "on-failure";
  		};
  		Install = {
    		WantedBy = [ "default.target" ];
  		};
	};



	services.hyprpaper = {
		enable = true;
		settings = {
			preload = "${./assets/images/Lumon.png}";
			wallpaper = ",${./assets/images/Lumon.png}";
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
