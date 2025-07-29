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

    # Non-flakes
    theme-bobthefish.url = "github:oh-my-fish/theme-bobthefish/e3b4d4eafc23516e35f162686f08a42edf844e40";
    theme-bobthefish.flake = false;
    fish-fzf.url = "github:jethrokuan/fzf/24f4739fc1dffafcc0da3ccfbbd14d9c7d31827a";
    fish-fzf.flake = false;
    fish-foreign-env.url = "github:oh-my-fish/plugin-foreign-env/dddd9213272a0ab848d474d0cbde12ad034e65bc";
    fish-foreign-env.flake = false;

    dotfiles = {
      url = "github:sknutsen/dotfiles";
      flake = false;
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
