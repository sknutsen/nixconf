{
  inputs,
  lib,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
in {
  imports = [
  ];

  programs = {
    zdkhypr.enable = true;
    zdkshell = {
      enable = true;
      package = inputs.zdesktop.inputs.quickshell.packages.${system}.default;
      configPackage = inputs.zdesktop.packages.${system}.zdkshell-config;

      systemd.enable = false;
    };

    # zdesktop binds quickshell to hyprland-session.target (HM hyprland module).
    # This host uses programs.hyprland.withUWSM, which activates graphical-session.target.
    quickshell.systemd.target = lib.mkForce "graphical-session.target";
  };
}
