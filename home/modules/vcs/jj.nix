{pkgs, ...}: {
  programs.jujutsu = {
    enable = false;
    settings = builtins.readFile ./jujutsu.toml;
  };
}
