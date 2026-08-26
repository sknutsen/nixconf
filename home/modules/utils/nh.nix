{
  inputs,
  pkgs,
  ...
}: {
  programs.nh = {
    enable = pkgs.stdenv.hostPlatform.isDarwin;
  };
}
