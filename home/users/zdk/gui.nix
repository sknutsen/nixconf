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

  home = {
    packages = with pkgs; [
      _1password-gui
      gimp3
      handbrake
      thunderbird
    ];
  };

  programs.cursor = {
    enable = true;
  };
}
