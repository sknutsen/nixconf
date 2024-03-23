{ config, lib, pkgs, inputs, ... }:
{
  imports = [
    ./modules/firefox.nix
    ./modules/syncthing.nix
    ../../modules/home-manager.hyprland.nix
  ];
  home = {
    packages = with pkgs; [
      alsa-utils
      gimp
      git-credential-keepassxc
      keepassxc
      logseq
      obsidian
      pavucontrol
      qbittorrent
      rclone
      rclone-browser
      thunderbird
      wdisplays
      zathura
    ];
  };

  qt = {
    enable = true;
    platformTheme = "gnome";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  gtk = {
    enable = true;
    theme.package = pkgs.arc-theme;
    theme.name = "Arc-Dark";
    iconTheme.package = pkgs.arc-icon-theme;
    iconTheme.name = "Arc";
  };

  xdg.enable = true;
}
