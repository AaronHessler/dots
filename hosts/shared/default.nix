{ config, lib, pkgs, stateVersion, ... }:

{
	nixpkgs.config.allowUnfree = true;
	nix.settings.experimental-features = [ "nix-command" "flakes" ];

  	boot.loader.systemd-boot.enable = true;
  	boot.loader.efi.canTouchEfiVariables = true;

  	networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

	time.timeZone = "Europe/Zurich";

  	fonts.enableDefaultPackages = true;

	# i18n.defaultLocale = "en_US.UTF-8";
	console = {
		keyMap = "de-latin1";
	};


  	environment.systemPackages = with pkgs; [
    		neovim
    		kitty
    		neofetch
		home-manager
		firefox
		slurp
		grim
		wl-clipboard-rs
		hyprcursor
		nautilus
		gnome-builder
  	];  

  	programs.hyprland = {
  		enable = true;
		xwayland.enable = true;
  	};

	programs.nh = {
		enable = true;
		clean.enable = true;
		flake = "/home/aaron/dots";
	};

  	hardware = {
  		graphics.enable = true;
  	};

  	#services.printing.enable = true;

   	services.pipewire = {
     		enable = true;
     		pulse.enable = true;
   	};

  	services.libinput.enable = true;

   	security = {
		sudo = {
			wheelNeedsPassword = false;
		};
   	};

  	system.stateVersion = stateVersion;

}

