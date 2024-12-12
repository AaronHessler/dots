{ pkgs, stateVersion, user, config, ... }: {
	home.packages = with pkgs; [
		spotify
		ferdium
		obsidian
		discord
		vscode
		jetbrains.rust-rover
		jetbrains.webstorm

		#Web
		tor-browser

		amberol
		hyprpaper
		krita
		btop
		steam
		overskride
		whatsapp-for-linux
		chromium
		#osu-lazer # Drawing tablet coordination
		figma-agent
		figlet

		geogebra
	];


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
    		ExecStart = "${pkgs.figma-agent}/bin/figma-agent";
    		Restart = "on-failure";
  		};
  		Install = {
    		WantedBy = [ "default.target" ];
  		};
	};



	services.hyprpaper = {
		enable = true;
		settings = {
			preload = "${./assets/images/Icon.png}";
			wallpaper = ",${./assets/images/Icon.png}";
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
