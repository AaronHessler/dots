{ config, lib, pkgs, stateVersion, unstable-pkgs, ... }:

{
  imports =
    [
      ./hardware.nix
    ];

  networking.hostName = "predator";

  environment.systemPackages = with pkgs; [
    pkgs.python312Packages.liquidctl
    lm_sensors
    cudatoolkit
  ];  

  programs.wireshark = {
    enable = true;
    package = pkgs.wireshark;
  };

  services.ollama = {
    package = unstable-pkgs.ollama;
    enable = true;
    acceleration = "cuda";
  };

   users.extraGroups.vboxusers.members = [ "aaron" ];

   programs.coolercontrol.enable = true;
   programs.coolercontrol.nvidiaSupport = true;


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

