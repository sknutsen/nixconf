{
  description = "nixos config";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };

    # Build a custom WSL installer
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      # IMPORTANT: we're using "libgbm" and is only available in unstable so ensure
      # to have it up-to-date or simply don't specify the nixpkgs input
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    darwin,
    ...
  } @ inputs: let
    overlays = [];

    mkSystem = import ./lib/mkSystem.nix {
      inherit overlays nixpkgs inputs;
    };
  in {
    nixosConfigurations = {
      pingu = mkSystem "pingu" {
        system = "x86_64-linux";
        user = "zdk";
      };

      socrates = mkSystem "socrates" {
        system = "x86_64-linux";
        user = "zdk";
      };

      wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "zdk";
        wsl = true;
      };
    };

    darwinConfigurations = {
      remorse = mkSystem "remorse" {
        system = "aarch64-darwin";
        user = "zdk";
        darwin = true;
      };
    };
  };
}
