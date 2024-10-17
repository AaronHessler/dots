{ pkgs, stateVersion, user, ... }: {
	home.packages = with pkgs; [
		spotify
		ferdium
		obsidian
		discord
		vscode
		firefox
		amberol
		hyprpaper
		krita
		btop
		steam
		overskride
		whatsapp-for-linux
		chromium
		#osu-lazer # Drawing tablet coordination
		flatpak
		figma-agent
		figlet
	];


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
			preload = "${./assets/images/Dragonfly.png}";
			wallpaper = ",${./assets/images/Dragonfly.png}";
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

	# Migrated to .nix file (hyprland.nix)
	#home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf; # Translate into nix
}
