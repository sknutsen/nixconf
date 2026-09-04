{
  inputs,
  pkgs,
  ...
}: {
  services.sketchybar = {
    enable = false;
    package = pkgs.sketchybar;
    extraPackages = [
      pkgs.jq
    ];
  };
}
