{ config, lib, pkgs, stateVersion, ... }:
{
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

	fonts.fontconfig = {
		enable = true;
		hinting = {
			enable = false;
			style = "slight";
		};
		antialias = true;
		subpixel.lcdfilter = "light";
	};

	# Make executables work
	programs.nix-ld.enable = true;

	# Drives show up in nautilus.
	services.udisks2.enable = true;
	security.polkit.enable = true;
	services.gvfs.enable = true;

	hardware.bluetooth.enable = true;
  	hardware.bluetooth.powerOnBoot = true;

	# For xremap
	hardware.uinput.enable = true;

	programs.hyprland.enable = true;
	services.displayManager.ly = {
		enable = true;
	};

	boot = {
		kernelParams = [
			"uinput"
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
			#timeout = 0; # Only enable if system is completly stable. (Ha, it's not.)
			systemd-boot.enable = true;
			efi.canTouchEfiVariables = true;
		};
	};
	
  	services.pipewire = {
     	enable = true;
     	pulse.enable = true;
		alsa.enable = true;
		wireplumber.enable = true;
  	};

	boot.plymouth = {
		enable = true;
		theme = "breeze";
	};

  	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.
	networking.firewall.allowedTCPPorts = [
		8080
		5173 # Vite
		4173 # Vite
	];

	time.timeZone = "Europe/Zurich";

  	fonts.enableDefaultPackages = true;

	programs.coolercontrol = {
		enable = true;
		nvidiaSupport = true;
	};

	# i18n.defaultLocale = "en_US.UTF-8";
	console = {
		keyMap = "de-latin1";
	};

	fonts.fonts = with pkgs; [
		nerd-fonts.jetbrains-mono
		google-fonts
	];

  	environment.systemPackages = with pkgs; [
    	neovim
		home-manager


		# Startup sound
		alsa-utils
		
		xdg-utils # Default, apps etc

		libva
		ffmpeg-full

		flatpak
		ncurses
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

	users.defaultUserShell = pkgs.nushell;

	programs.dconf.enable = true;

	programs.nh = {
		enable = true;
		clean.enable = true;
	};

	environment.sessionVariables = {
		NH_FLAKE = "/home/aaron/dots"; # Change this to your location
	};

  	hardware = {
  		graphics.enable = true;
		#graphics.enable32Bit = true;

		opentabletdriver = {
			enable = false;
			daemon.enable = false;
		};

		opengl = {
			enable = true;
			driSupport32Bit = true;
		};
  	};

	# NOTICE: Disabled CUPS because it has a newly discovered vulnerability.
  	#services.printing.enable = true;
	services.pcscd.enable = true;



  	services.libinput.enable = true;

   	security = {
		sudo = {
			wheelNeedsPassword = false;
		};
   	};

  	system.stateVersion = stateVersion;
}

