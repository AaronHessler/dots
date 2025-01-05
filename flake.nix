{
  description = "ApexOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
    	url = "github:nix-community/home-manager/release-24.11";
		inputs.nixpkgs.follows = "nixpkgs";
    };
	xremap.url = "github:xremap/nix-flake";
	terminaltexteffects.url = "github:ChrisBuilds/terminaltexteffects/";
	nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
	stylix.url = "github:danth/stylix";
	zen-browser.url = "github:MarceColl/zen-browser-flake";
  };

  outputs = inputs@{
	self,
	nixpkgs,
	nixpkgs-unstable,
	home-manager,
	xremap,
	terminaltexteffects,
	nix-flatpak,
	stylix,
	zen-browser
}: 
  let
  	globalUsers = import ./hosts/users/global;
  	sharedHost = import ./hosts/shared;
  	sharedHome = import ./users/shared;
	system = "x86_64-linux";
	stateVersion = "24.05";

	unstable-pkgs = import nixpkgs-unstable { inherit system; config.allowUnfree = true; };	

	mkHost = {
		modules,
	}: nixpkgs.lib.nixosSystem {
		specialArgs = { inherit stateVersion system unstable-pkgs; };
		inherit system;
		modules = [ globalUsers sharedHost ] ++ modules;
	};

	mkHome = {
		modules,
		user ? "dragonfly",

	}:	home-manager.lib.homeManagerConfiguration {
		pkgs = import nixpkgs {
			inherit system;
			config.allowUnfree = true;
		};
		modules = [
			sharedHome
			xremap.homeManagerModules.default
			nix-flatpak.homeManagerModules.nix-flatpak
			stylix.homeManagerModules.stylix
		] ++ modules;
		extraSpecialArgs = {inherit stateVersion user inputs terminaltexteffects system unstable-pkgs;};
	};

  in
  {
	nixosConfigurations = {
		predator = mkHost { modules = [ ./hosts/predator ]; };
		stalker = mkHost { modules = [ ./hosts/stalker ]; };
		prey = mkHost { modules = [ ./hosts/prey ]; };
	};
	homeConfigurations = {
		aaron = mkHome { modules = [ ./users/aaron ]; user = "aaron"; };
	};
  };
}
