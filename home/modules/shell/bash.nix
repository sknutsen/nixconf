{pkgs, ...}: {
  programs.bash = {
    enable = true;
    shellOptions = [];
    historyControl = ["ignoredups" "ignorespace"];
    # initExtra = builtins.readFile ./bashrc;
    # shellAliases = shellAliases;
  };
}
