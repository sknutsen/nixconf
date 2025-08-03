{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./bash.nix
    (import ./fish.nix {inherit inputs lib pkgs;})
    # ./zsh.nix
  ];
}
