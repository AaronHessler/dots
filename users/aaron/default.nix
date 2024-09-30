{ pkgs, stateVersion, user, ... }: {
	home.packages = with pkgs; [
		spotify
		ferdium
		obsidian
		discord
		vscode
		steam
		firefox
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
			settings = { # Don't touch, works, no idea why.
				version = "1";
				prompt = "enabled";
				git_protocol = "https";
			};
		};
	};


	home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf; # Translate into nix
}
