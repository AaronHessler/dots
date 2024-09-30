{ config, lib, pkgs, stateVersion, ... }:

{
  imports =
    [
      ./hardware.nix
    ];



  networking.hostName = "prey";

  environment.systemPackages = with pkgs; [
  ];  

  # For Hyprland
  environment.sessionVariables = {
    XDG_SESSION_TYPE = "wayland";
  	WLR_NO_HARDWARE_CURSORS = "1";
	  NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT="auto";
  };

}

