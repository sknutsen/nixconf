# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "socrates"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";
  i18n.inputMethod.enabled = "ibus";
  i18n.inputMethod.ibus.engines = with pkgs.ibus-engines; [ anthy ];
  console = {
    font = "Lat2-Terminus16";
    useXkbConfig = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Configure keymap in X11
  #services.xserver = {
  #  layout = "no";
  #  xkbVariant = "";
  #};

  # Configure console keymap
  #console.keyMap = "no";

  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  hardware.pulseaudio.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zdk = {
    isNormalUser = true;
    description = "Sondre Knutsen";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      tree
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    swaybg
    swayidle
    wlogout
    wl-clipboard
    hyprpicker
    grim
    slurp
    libnotify
    pkgs.dunst
    yad
    alsa-utils
    mpd
    mpc-cli
    ncmpcpp
    networkmanagerapplet
    xfce.thunar
    git
    curl
    kitty
    pkgs.eww-wayland
    pkgs.home-manager
    vscodium
    direnv
    rofi-wayland
    socat
    jq
    python3
    neofetch
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # Hyprland
  programs = {
    hyprland = {
      enable = true;

      xwayland = {
        enable = true;
        hidpi = true;
      };
    };

    # Monitor backlight control
    light.enable = true;

    # Thunar file manager related options
    thunar.plugins = with pkgs.xfce; [
      thunar-archive-plugin
      thunar-volman
    ];

    zsh.enable = true;
    
    dconf.enable = true;
  };

  # Optional, hint electron apps to use wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  security.pam.services.swaylock = {};

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
    ];
  };

  services = {
    tumbler.enable = true;
    xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = true;
      };
      layout = "no";
      libinput.enable = true;
      displayManager = {
        defaultSession = "hyprland";
        lightdm.enable = false;
        gdm = {
          enable = true;
          wayland = true;
        };
      };
    };
    printing.enable = true;
    flatpak.enable = true;
    dbus.packages = [ pkgs.gcr ];
    geoclue2.enable = true;
    udev.packages = with pkgs; [
      gnome.gnome-settings-daemon
      platformio
      openocd
    ];
    upower.enable = true;
  };

  services.keyd = {
    enable = true;
    settings = {
      main = {
        capslock = "overload(control, esc)";
      };
    };
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
