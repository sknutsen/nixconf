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
      yaak

      inputs.t3code.packages.x86_64-linux.default
    ];
  };

  programs = {
    cursor = {
      enable = true;
    };

    rofi = {
      enable = true;
      theme = "material";
    };
  };
}
