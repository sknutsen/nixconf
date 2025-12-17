{
  config,
  inputs,
  pkgs,
  ...
}: let
  isDarwin = pkgs.stdenv.isDarwin;
  isLinux = pkgs.stdenv.isLinux;
in {
  programs.ghostty = {
    enable = !isDarwin && isLinux;
    enableZshIntegration = true;

    settings = {
      background-opacity = 0.8;
      background-blur = true;

      font-size = 14;

      shell-integration-features = "cursor,no-sudo,title,ssh-env,ssh-terminfo";
    };

    # themes = [];
  };
}
