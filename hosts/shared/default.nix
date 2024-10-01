{ config, lib, pkgs, stateVersion, ... }:
{
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	boot = {
		kernelParams = [
			"quiet"
      		"splash"
			"boot.shell_on_fail"
			"loglevel=3"
			"rd.systemd.show_status=false"
			"rd.udev.log_level=3"
			"udev.log_priority=3"
		];
		consoleLogLevel = 0;
		initrd.verbose = false;
		loader = {
			#timeout = 0; # Only enable if system is completly stable.
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};
	
  	services.pipewire = {
     	enable = true;
     	pulse.enable = true;
  	};
  
	boot.plymouth = {
		enable = true;
		theme = "breeze";
	};

  	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	time.timeZone = "Europe/Zurich";

  	fonts.enableDefaultPackages = true;

	# i18n.defaultLocale = "en_US.UTF-8";
	console = {
		keyMap = "de-latin1";
	};

  	environment.systemPackages = with pkgs; [
    	neovim
    	neofetch
		home-manager
		nerdfonts
		zsh


		# JS Development
		deno # JS Runtime
		pnpm
		nodejs

		# Rust Development
		cargo
		rustc
		gcc

		# Startup sound
		alsa-utils
  	];  
	   

	# Startup sound
	systemd.services.startupSound = {
		enable = false; # TODO: Make this work
    	description = "startup sound";
    	wants = ["sound.target"];
      	after = ["sound.target"];
      	wantedBy = ["sound.target"];
    	serviceConfig = {
    	  Type = "oneshot";
    	  ExecStart = "${pkgs.alsa-utils}/bin/aplay ${./assets/audio/boot.wav}";
		  RemainAfterExit = false;
    	};
  	};

	users.defaultUserShell = pkgs.zsh;

	programs.zsh = {
		enable = true;
	};

	programs.dconf.enable = true;

	programs.nh = {
		enable = true;
		clean.enable = true;
		flake = "/home/aaron/dots";
	};

  	hardware = {
  		graphics.enable = true;
		graphics.enable32Bit = true;
		pulseaudio.support32Bit = true;
  	};

	# NOTICE: Disabled CUPS because it has a newly discovered vulnerability.
  	#services.printing.enable = true;


  	services.libinput.enable = true;

   	security = {
		sudo = {
			wheelNeedsPassword = false;
		};
   	};

  	system.stateVersion = stateVersion;
}

