{
	description = "nixos config";
	
	inputs = {
		nixpkgs = {
			url = "github:NixOS/nixpkgs/nixos-unstable";
		};

		home-manager = {
			url = "github:nix-community/home-manager";
			inputs.nixpkgs.follows = "nixpkgs";
		};
    		
		hyprland.url = "github:hyprwm/Hyprland";

		nixvim = {
			url = "github:nix-community/nixvim";
			# If using a stable channel you can use `url = "github:nix-community/nixvim/nixos-<version>"`
			inputs.nixpkgs.follows = "nixpkgs";
		};
	};

	outputs = { ... } @ inputs: 
	let
		# lib = nixpkgs.lib;
		myLib = import ./lib/default.nix {inherit inputs;};
	in 
	   with myLib; {
		nixosConfigurations = {
			zdknixos = mkSystem ./hosts/zdknixos/configuration.nix;
		};

		#homeConfiguration = {
		#	"zdk@zdknixos" = mkHome "x86_64-linux" ./hosts/zdknixos/home.nix;
		#};

      homeManagerModules.default = ./modules/home-manager;
      nixosModules.default = ./modules/nixos;
	};
}
