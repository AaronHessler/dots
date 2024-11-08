{ config, lib, pkgs, stateVersion, ... }:

{
  imports =
    [
      ./hardware.nix
    ];


  networking.hostName = "predator";

  environment.systemPackages = with pkgs; [
		modrinth-app
    pkgs.python312Packages.liquidctl
    ollama
  ];  


		#pulseaudio.support32Bit = true; # Enable sound


  # For Hyprland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
  	WLR_NO_HARDWARE_CURSORS = "1";
	  NIXOS_OZONE_WL = "1";
    XDG_SESSION_TYPE = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT="wayland";
    SDL_VIDEODRIVER="wayland";
  };

}

