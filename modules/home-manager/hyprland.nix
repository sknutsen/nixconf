{ pkgs, lib, config, ... }:

  let
    startupScript = pkgs.pkgs.writeShellScriptBin "start" ''
      ${pkgs.waybar}/bin/waybar &
      ${pkgs.swww}/bin/swww init &
  
      #sleep 1
  
      #${pkgs.swww}/bin/swww img ${./wallpaper.png} &
    '';
in
{
   programs.hyprland = {
      enable = true;
      xwayland.enable = true;

      plugins = [
         inputs.hyprland-plugins.packages."${pkgs.system}".borders-plus-plus
      ];

      settings = {
         exec-once = ''${startupScript}/bin/start'';
      };
   };
}
