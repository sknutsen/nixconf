# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{

   # Bootloader.
   #boot.loader.systemd-boot.enable = true;
   #boot.loader.efi.canTouchEfiVariables = true;
   boot = {
      loader = {
         efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi";
         };
         grub = {
            enable = true;
            efiSupport = true;
            devices = [ "nodev" ];
            useOSProber = true;
         };
         timeout = 5;
      };
   };

  # networking.hostName = ""; # Define your hostname.
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
   i18n = {
      defaultLocale = "en_GB.UTF-8";
      inputMethod = {
         enabled = true;
         ibus = {
            engines = with pkgs.ibus-engines; [ anthy ];
         };
      };
   };

  # Configure console keymap
   console = {
      keyMap = "no";
      font = "Lat2-Terminus16";
      useXkbConfig = true;
   };

   security = {
      pam.services.greetd.enableGnomeKeyring = true;
      polkit.enable = true;
      rtkit.enable = true;
   };

   services = {
      blueman.enable = true;
      dbus.packages = [ pkgs.gcr ];
      flatpack.enable = true;
      geoclue2.enable = true;
      gnome.gnome-keyring.enable = true;
      keyd = {
         enable = true;
         settings = {
            main = {
               capslock = "overload(control, esc)";
            };
         };
      };
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
         gnome.gnome-settings.daemon;
         openocd
         platformio
      ];
      upower.enable = true;
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
         layout = "no";
         libinput.enable = true;
         xkbVariant = "";
      };
   };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zdk = {
    isNormalUser = true;
    description = "Sondre Knutsen";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    git
    home-manager
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];

   programs = {
      # Some programs need SUID wrappers, can be configured further or are
      # started in user sessions.
      mtr.enable = true;
      gnupg.agent = {
         enable = true;
         enableSSHSupport = true;
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
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

}
