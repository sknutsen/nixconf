{
  config,
  inputs,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
  active =
    if isLinux
    then "#B4BEFE"
    else "FFFFFF";
  inactive = "#CDD6F3";
in {
  programs.hyprpanel = {
    enable = false;

    settings = {
      ###########################################################
      ## Bar ####################################################
      # Clock
      bar.clock.format = "%H:%M %d.%m";

      # Launcher
      bar.launcher.autoDetectIcon = true;

      # Layouts
      "bar.layouts" = {
        "DP-2" = {
          left = ["dashboard" "workspaces" "windowtitle"];
          middle = ["media"];
          right = [
            "volume"
            "network"
            "bluetooth"
            "systray"
            "clock"
            "notifications"
          ];
        };
        "*" = {
          left = ["workspaces"];
        };
      };

      # Workspaces
      bar.workspaces.show_icons = true;
      bar.workspaces.showApplicationIcons = true;

      ###########################################################
      ## Menus ##################################################
      # Clock
      menus.clock = {
        time = {
          military = true;
          hideSeconds = true;
        };
        weather.unit = "metric";
      };

      # Dashboard
      menus.dashboard.directories.enabled = false;
      menus.dashboard.stats.enable_gpu = true;

      ###########################################################
      ## Theme ##################################################
      # Bar
      theme.bar.transparent = true;
      theme.bar.buttons.bluetooth.icon = active;
      theme.bar.buttons.bluetooth.text = active;
      theme.bar.buttons.clock.icon = active;
      theme.bar.buttons.clock.text = active;
      theme.bar.buttons.dashboard.icon = active;
      theme.bar.buttons.media.icon = active;
      theme.bar.buttons.media.text = active;
      theme.bar.buttons.network.icon = active;
      theme.bar.buttons.network.text = active;
      theme.bar.buttons.volume.icon = active;
      theme.bar.buttons.volume.text = active;
      theme.bar.buttons.windowtitle.icon = active;
      theme.bar.buttons.windowtitle.text = active;
      theme.bar.buttons.workspaces.active = active;
      theme.bar.buttons.workspaces.hover = active;
      theme.bar.buttons.workspaces.available = inactive;
      theme.bar.buttons.workspaces.occupied = inactive;

      # Font
      theme.font = {
        name = "CaskaydiaCove NF";
        size = "16px";
      };
    };
  };
}
