{ pkgs, unstable-pkgs, stateVersion, user, config, ... }: {
	home.packages = 

		(with pkgs; [
		obsidian
		hyprpaper
		btop
		overskride
		figlet
		geogebra

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
		cargo
		rust-analyzer
		rustc
		#rustup
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

		nixvim = {
			opts = {
				tabstop = 4;
				shiftwidth = 4;
				softtabstop = 4;
				expandtab = true;
    		};
			enable = true;
			plugins = {
				lualine.enable = true;
				luasnip.enable = true;
				lsp = {
					enable = true;
					servers = {
						rust_analyzer = {
							enable = true;
							installCargo = true;
							installRustc = true;
						};
						jdtls.enable = true;
						nixd.enable = true;
						marksman.enable = true;
					};
				};
				cmp = {
					enable = true;
					autoEnableSources = true;
					settings.sources = [
						{ name = "nvim_lsp"; }
						{ name = "path"; }
						{ name = "buffer"; }
						{ name = "luasnip"; }
					];
					settings.mapping = {
						"<Tab>" = "cmp.mapping.confirm({ select = true })";
						"<CR>" = "cmp.mapping.confirm({ select = true })";
						"<Up>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
						"<Down>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
					};
				};
			};
		};
	};
}
