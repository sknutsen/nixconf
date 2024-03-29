# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "zdk_nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  # Set your time zone.
  time.timeZone = "Europe/Oslo";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  # Enable the X11 windowing system.
 # services.xserver.enable = true;

#  services.blueman.enable = true;

   security = {
      pam.services.greetd.enableGnomeKeyring = true;
      polkit.enable = true;
      rtkit.enable = true;
   };

   services = {
      blueman.enable = true;
      dbus.packages = [ pkgs.gcr ];
#      flatpack.enable = true;
      #geoclue2.enable = true;
      gnome.gnome-keyring.enable = true;
      #keyd = {
      #   enable = true;
      #   settings = {
      #      main = {
      #         capslock = "overload(control, esc)";
      #      };
      #   };
      #};
      openssh.enable = true;
      pipewire = {
          enable = true;
          alsa.enable = true;
          alsa.support32Bit = true;
          pulse.enable = true;
          # If you want to use JACK applications, uncomment this
          #jack.enable = true;

          # use the example session manager (no others are packaged yet so this is enabled by default,
          # no need to redefine it in your config for now)
          #media-session.enable = true;
      };
      printing.enable = true;
      tumbler.enable = true;
      udev.packages = with pkgs; [
         gnome.gnome-settings-daemon
         openocd
         platformio
      ];
      # upower.enable = true;
      xserver = {
         enable = true;
         
         desktopManager = {
            xfce.enable = false;
            xterm.enable = true;
         };
         displayManager = {
            defaultSession = "hyprland";
            gdm = {
               enable = true;
               wayland = true;
            };
            lightdm.enable = false;
         };
         libinput.enable = true;
         xkb = {
            layout = "no";
            variant = "";
         };
      };
   };

  # Enable the XFCE Desktop Environment.
  #services.xserver.displayManager.lightdm.enable = false;
  #services.xserver.desktopManager.xfce.enable = false;

  # Configure keymap in X11
  services.xserver = {
    layout = "no";
    xkbVariant = "";
  };

   programs = {
      dconf.enable = true;
   
      gnupg.agent = {
         enable = true;
         enableSSHSupport = true;
      };
   
      hyprland = {
         enable = true;
         package = inputs.hyprland.packages."${pkgs.system}".hyprland;
         
         xwayland = {
            enable = true;
         };
      };
      
      light.enable = true;
      
      mtr.enable = true;
      
      thunar = {
         plugins = with pkgs.xfce; [
            thunar-archive-plugin
            thunar-volman
         ];
      };
      
      zsh.enable = true;
   };

  # Configure console keymap
  console.keyMap = "no";

  # Enable CUPS to print documents.
#  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
#  security.rtkit.enable = true;
 # services.pipewire = {
   # enable = true;
    #alsa.enable = true;
    #alsa.support32Bit = true;
    #pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  #};

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zdk = {
    isNormalUser = true;
    description = "Sondre Knutsen";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
    #  thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
   alsa-utils
   curl
   direnv
   dunst
   hyprpicker
   jq
   libnotify
   ncmpcpp
   neofetch
   networkmanagerapplet
   python3
   rofi-wayland
   socat
   swaybg
   swayidle
   wlogout
   wl-clipboard
   xfce.thunar
   yad
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
