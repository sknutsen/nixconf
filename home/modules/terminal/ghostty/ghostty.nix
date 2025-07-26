{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      background-opacity = 0.8;
      background-blur = true;

      font-size = 14;
    };

    # themes = [];
  };
}
