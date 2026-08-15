{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hyprpanel.nix
    (import ./zdesktop.nix {inherit inputs lib pkgs;})
  ];
}
