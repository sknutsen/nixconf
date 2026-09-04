{
  inputs,
  pkgs,
  ...
}: let
  # Single SDK derivation for workloads, PATH, and activation (avoid mixing with pkgs.dotnet-sdk).
  dotnetSdk = pkgs.dotnetCorePackages.sdk_10_0;

  androidComposition = pkgs.androidenv.composeAndroidPackages {
    # Last three major API levels — enough for MAUI multi-targeting without pulling five years of platforms.
    numLatestPlatformVersions = 3;

    includeNDK = true;
    includeEmulator = "if-supported";
    includeSystemImages = "if-supported";
    systemImageTypes = ["google_apis_playstore"];
    abiVersions = ["arm64-v8a"];

    includeExtras = ["extras;google;auto"];
  };

  androidSdkHome = "${androidComposition.androidsdk}/libexec/android-sdk";
in {
  imports = [
    ../../modules/darwin
  ];

  # Required for pkgs.androidenv (see pkgs/development/mobile/androidenv/license.nix).
  nixpkgs.config.android_sdk.accept_license = true;

  homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    brews = [
      "kubectl"
      # "siderolabs/tap/talosctl@1.6.3"
    ];

    casks = [
      "font-hack-nerd-font"
      "ghostty"
    ];
  };

  environment.variables = {
    ANDROID_HOME = androidSdkHome;
    ANDROID_SDK_ROOT = androidSdkHome;
    ANDROID_NDK_ROOT = "${androidSdkHome}/ndk-bundle";
    JAVA_HOME = "${pkgs.jdk.home}";
  };

  environment.shells = with pkgs; [
    bashInteractive
    fish
    zsh
  ];

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages =
    [
      dotnetSdk
      androidComposition.androidsdk
    ]
    ++ (with pkgs; [
      cachix
      cursor-cli
      go
      jdk
      jetbrains.rider
      vim
    ]);

  nix.enable = true;
  nix.package = pkgs.lixPackageSets.latest.lix;
  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # We need to enable flakes
  nix.extraOptions = ''
    experimental-features = nix-command flakes
    keep-outputs = true
    keep-derivations = true
  '';

  # Enable the Linux builder so we can run Linux builds on our Mac.
  # This can be debugged by running `sudo ssh linux-builder`
  nix.linux-builder = {
    enable = false;
    ephemeral = true;
    maxJobs = 4;
    config = {pkgs, ...}: {
      # Make our builder beefier since we're on a beefy machine.
      virtualisation = {
        cores = 4;
      };

      # Add some common debugging tools we can see whats up.
      environment.systemPackages = with pkgs; [
      ];
    };
  };

  nix.settings.trusted-users = ["@admin"];

  # Enable alternative shell support in nix-darwin.
  # programs.fish.enable = true;

  # Set Git commit hash for darwin-version.
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 6;

  system.primaryUser = "zdk";

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  users.users.zdk = {
    home = "/Users/zdk";
    shell = pkgs.fish;
  };
  security.pam.services.sudo_local.touchIdAuth = true;

  programs = {
    # xcode.enable = true;
    fish = {
      enable = true;
      shellInit = ''
        # Nix
        if test -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
          source '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish'
        end
        # End Nix
      '';
    };

    zsh = {
      enable = true;
      shellInit = ''
        # Nix
        if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
          . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
        fi
        # End Nix
      '';
    };
  };
}
