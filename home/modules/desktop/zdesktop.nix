{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
  ];

  programs = {
    zdkhypr.enable = true;
    zdkshell = {
      enable = true;

      systemd.enable = false;
    };

    # zdesktop binds quickshell to hyprland-session.target (HM hyprland module).
    # This host uses programs.hyprland.withUWSM, which activates graphical-session.target.
    quickshell.systemd.target = lib.mkForce "graphical-session.target";
  };
}
