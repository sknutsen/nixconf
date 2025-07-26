{
  config,
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    spotify
  ];

  services.mpd = {
    enable = true;

    musicDirectory = "~/Music";
  };

  # networking.firewall = {
  # allowedTCPPorts = [57621];
  # allowedUDPPorts = [5353];
  # };
}
