{pkgs, ...}: {
  programs.git = {
    enable = true;

    userName = "Sondre Knutsen";
    userEmail = "sondreknutsen1@gmail.com";

    extraConfig = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "sknutsen";
      push.default = "tracking";
      init.defaultBranch = "main";
    };
  };
}
