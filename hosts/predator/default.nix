{ config, lib, pkgs, stateVersion, ... }:

{
  imports =
    [
      ./hardware.nix
    ];



  networking.hostName = "predator";

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware = {
	nvidia = {
		modesetting.enable = true;
		open = false;
		nvidiaSettings = true;
		package = config.boot.kernelPackages.nvidiaPackages.stable;
	};
  };

  environment.systemPackages = with pkgs; [
  ];  

  environment.sessionVariables = {
  	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
  };

}

