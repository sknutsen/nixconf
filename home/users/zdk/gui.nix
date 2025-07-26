{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ../../modules/browser
    ../../modules/comms
    ../../modules/desktop
    ../../modules/media
    ../../modules/terminal
  ];
  home.packages = with pkgs; [
    _1password-gui
    thunderbird
  ];

  programs = {
    librewolf = {
      enable = true;
    };
  };
}
