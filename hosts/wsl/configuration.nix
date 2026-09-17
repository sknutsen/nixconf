{
  currentSystemUser,
  pkgs,
  ...
}: {
  wsl = {
    enable = true;
    defaultUser = currentSystemUser; # zdk
    startMenuLaunchers = true;
    useWindowsDriver = true; # GPU / WSLg
    wslConf = {
      automount.root = "/mnt";
      network.generateResolvConf = true;
      # true: Windows az/git/code on PATH. false: cleaner Linux PATH.
      interop.appendWindowsPath = true;
    };
  };

  networking.hostName = "wsl";
  time.timeZone = "Europe/Oslo";

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    keep-outputs = true;
    keep-derivations = true;
  };

  nixpkgs.config.allowUnfree = true;

  programs.fish.enable = true;
  programs.nix-ld.enable = true;
  programs.nh.enable = true;

  users.defaultUserShell = pkgs.fish;
  users.users.${currentSystemUser} = {
    isNormalUser = true;
    shell = pkgs.fish;
  };

  environment.systemPackages = with pkgs; [git wget curl];

  # WSL owns kernel, init, and networking. Do not enable boot.loader,
  # greetd, Hyprland, PipeWire, NetworkManager, Steam, getty autologin,
  # or hardware-configuration.

  system.stateVersion = "25.05";
}
