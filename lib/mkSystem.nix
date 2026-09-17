{
  nixpkgs,
  overlays,
  inputs,
}: name: {
  system,
  user,
  darwin ? false,
  wsl ? false,
}: let
  # True if this is a WSL system.
  isWSL = wsl;

  # WSL is Linux; Darwin is the only non-Linux target this helper builds.
  isLinux = !darwin;

  # The config files for this system.
  machineConfig = ../hosts/${name}/configuration.nix;
  userHMConfig = ../home/users/${user}/home.nix;

  # NixOS vs nix-darwin functions
  systemFunc =
    if darwin
    then inputs.darwin.lib.darwinSystem
    else nixpkgs.lib.nixosSystem;
  home-manager =
    if darwin
    then inputs.home-manager.darwinModules
    else inputs.home-manager.nixosModules;
in
  systemFunc rec {
    inherit system;

    modules = [
      # Apply our overlays. Overlays are keyed by system type so we have
      # to go through and apply our system type. We do this first so
      # the overlays are available globally.
      {nixpkgs.overlays = overlays;}

      # Allow unfree packages.
      {nixpkgs.config.allowUnfree = true;}

      # Bring in WSL if this is a WSL build
      (
        if isWSL
        then inputs.nixos-wsl.nixosModules.default
        else {}
      )

      machineConfig

      # Pins org.freedesktop.impl.portal.Settings to gtk on Hyprland so
      # color-scheme reaches XWayland/Electron. No-op unless xdg.portal.enable.
      # Skip on WSL so that host stays obviously desktop-free.
      (
        if isLinux && !isWSL
        then inputs.zdesktop.nixosModules.default
        else {}
      )

      home-manager.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.backupFileExtension = "backup";
        home-manager.users.${user} = import userHMConfig {
          isWSL = isWSL;
          isDarwin = darwin;
          isLinux = isLinux;
          inputs = inputs;
        };
      }

      # We expose some extra arguments so that our modules can parameterize
      # better based on these values.
      {
        config._module.args = {
          currentSystem = system;
          currentSystemName = name;
          currentSystemUser = user;
          isWSL = isWSL;
          isDarwin = darwin;
          isLinux = isLinux;
          inputs = inputs;
        };
      }
    ];
  }
