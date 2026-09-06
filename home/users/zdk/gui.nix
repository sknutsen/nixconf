{
  inputs,
  lib,
  pkgs,
  ...
}: {
  config,
  ...
}: let
  zdesktopStyling =
    config.zdesktop.applySystemTheme
    && (config.programs.zdkhypr.enable || config.programs.zdkshell.enable);
in {
  imports = [
    ../../modules/browser
    ../../modules/comms
    (import ../../modules/desktop {inherit inputs lib pkgs;})
    ../../modules/media
    ../../modules/terminal
  ];

  home = {
    packages = with pkgs;
      [
        _1password-gui
        gimp3
        handbrake
        thunderbird
        yaak

        # Upstream t3code-nix sets `pkgs = pkgs` on the drv, which breaks evaluation.
        (callPackage ../../packages/t3code.nix {})
      ]
      ++ lib.optionals (!zdesktopStyling) [
        nwg-look
        libsForQt5.qt5ct
        libsForQt5.qtstyleplugin-kvantum
        kdePackages.qt6ct
        kdePackages.qtstyleplugin-kvantum
      ];
  };

  programs = {
    cursor = {
      enable = true;
    };

    rofi = {
      enable = true;
      theme = lib.mkIf (!zdesktopStyling) "material";
    };
  };
}
