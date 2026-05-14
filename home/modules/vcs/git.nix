{pkgs, ...}: {
  programs.git = {
    enable = true;

    signing.format = "openpgp";

    settings = {
      branch.autosetuprebase = "always";
      color.ui = true;
      core.askPass = ""; # needs to be empty to use terminal for ask pass
      credential.helper = "store"; # want to make this more secure
      github.user = "sknutsen";
      push.default = "tracking";
      init.defaultBranch = "main";

      user = {
        name = "Sondre Knutsen";
        email = "sondreknutsen1@gmail.com";
      };
    };
  };
}
