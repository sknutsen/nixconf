{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = pkgs.stdenv.hostPlatform.isLinux;
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
