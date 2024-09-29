{ pkgs, stateVersion, user, ... }: {
	home.packages = with pkgs; [
		hello
		spotify
		whatsapp-for-linux
		albert
		obsidian
		discord
		git
		vscode
		hyprcursor
	];

	programs = {
		git = {
			enable = true;
			userName = "Aaron Hessler";
			userEmail = "aaron_hessler@outlook.de";
			extraConfig.init = {
				defaultBranch = "main";	
			};
		};

		gh = {
			enable = true;
			settings = {
				version = "1";
				prompt = "enabled";
				git_protocol = "https";
			};
		};
	};

	home = {
		inherit stateVersion;
		username = user;
		homeDirectory = "/home/${user}";

		pointerCursor = { # TODO: Move to shared. (Implement shared.)
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

	home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
}
