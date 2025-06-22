{
  description = "ApexOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
	nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
    	url = "github:nix-community/home-manager/release-25.05";
		inputs.nixpkgs.follows = "nixpkgs";
    };
	xremap.url = "github:xremap/nix-flake";
	terminaltexteffects.url = "github:ChrisBuilds/terminaltexteffects/";
	nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=v0.4.1";
	stylix.url = "github:danth/stylix/release-25.05";
	zen-browser.url = "github:0xc000022070/zen-browser-flake";
	rust-overlay = {
    	url = "github:oxalica/rust-overlay";
    	inputs.nixpkgs.follows = "nixpkgs";
    };
	nixvim = {
        url = "github:nix-community/nixvim";
        inputs.nixpkgs.follows = "nixpkgs";
    };
	quickshell = {
		url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
		inputs.nixpkgs.follows = "nixpkgs";
    };
	anyrun = {
      url = "github:anyrun-org/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
	zen-browser,
	nixvim,
	rust-overlay,
	quickshell,
	anyrun
}: 
  let
  	globalUsers = import ./hosts/users/global;
  	sharedHost = import ./hosts/shared;
  	sharedHome = import ./users/shared;
	system = "x86_64-linux";
	stateVersion = "25.05";

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
			overlays = [ rust-overlay.overlays.default ];
		};
		modules = [
			sharedHome
			xremap.homeManagerModules.default
			nix-flatpak.homeManagerModules.nix-flatpak
			stylix.homeModules.stylix
			nixvim.homeManagerModules.nixvim
		] ++ modules;
		extraSpecialArgs = {inherit stateVersion user inputs terminaltexteffects system unstable-pkgs quickshell;};
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
