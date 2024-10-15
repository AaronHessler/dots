{
  description = "ApexOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
    	url = "github:nix-community/home-manager";
		inputs.nixpkgs.follows = "nixpkgs";
    };
	xremap.url = "github:xremap/nix-flake";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, xremap }: 

  let
  	globalUsers = import ./hosts/users/global;
  	sharedHost = import ./hosts/shared;
  	sharedHome = import ./users/shared;
	system = "x86_64-linux";
	stateVersion = "24.05";

	mkHost = {
		modules,
	}: nixpkgs.lib.nixosSystem {
		specialArgs = { inherit stateVersion system; };
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
		modules = [ sharedHome xremap.homeManagerModules.default ] ++ modules;
		extraSpecialArgs = {inherit stateVersion user;};
	};
  in
  {
	nixosConfigurations = {
		predator = mkHost { modules = [ ./hosts/predator ]; };
		prey = mkHost { modules = [ ./hosts/prey ]; };
	};
	homeConfigurations = {
		aaron = mkHome { modules = [ ./users/aaron ]; user = "aaron"; };
	};
  };
}
