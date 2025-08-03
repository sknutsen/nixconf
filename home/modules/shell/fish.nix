{
  inputs,
  lib,
  pkgs,
  ...
}: {
  programs.fish = {
    enable = true;
    shellAliases = builtins.fromTOML (builtins.readFile ./aliases.toml);
    interactiveShellInit = lib.strings.concatStrings (lib.strings.intersperse "\n" [
      "source ${inputs.theme-bobthefish}/functions/fish_prompt.fish"
      "source ${inputs.theme-bobthefish}/functions/fish_right_prompt.fish"
      "source ${inputs.theme-bobthefish}/functions/fish_title.fish"
      (builtins.readFile ./config.fish)
      "set -g SHELL ${pkgs.fish}/bin/fish"
    ]);

    plugins =
      map (n: {
        name = n;
        src = inputs.${n};
      }) [
        "fish-fzf"
        "fish-foreign-env"
        "theme-bobthefish"
      ];
  };

  programs.oh-my-posh = {
    enable = false;
  };
}
