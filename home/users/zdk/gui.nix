{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/browser
    ../../modules/comms
    (import ../../modules/desktop {inherit inputs lib pkgs;})
    ../../modules/media
    ../../modules/terminal
  ];

  home = {
    packages = with pkgs; [
      _1password-gui
      gimp3
      handbrake
      thunderbird
      yaak

      # Upstream t3code-nix sets `pkgs = pkgs` on the drv, which breaks evaluation.
      (callPackage ../../packages/t3code.nix {})
    ];
  };

  programs = {
    cursor = {
      enable = true;
    };

    rofi = {
      enable = true;
      theme = "material";
    };
  };
}
