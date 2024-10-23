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


		pulseaudio.support32Bit = true; # Enable sound


  # For Hyprland
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "nvidia";
    XDG_SESSION_TYPE = "wayland";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  	WLR_NO_HARDWARE_CURSORS = "1";
	  NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT="wayland";
  };

}

