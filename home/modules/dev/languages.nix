{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    go
    zig
  ];
}
