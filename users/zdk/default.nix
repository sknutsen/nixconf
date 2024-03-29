{ config, lib, pkgs, inputs, headless ? true, ... }:

{
  imports = [  ] ++ lib.optional (!headless) ./desktop.nix;

  manual.manpages.enable = false;

  home = {
    username = "zdk";
    homeDirectory = "/home/zdk";
    packages = with pkgs; [
      file
      ripgrep
      fd
      magic-wormhole
      unzip
      btop
      htop
      pciutils
    ];
  };

  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;
      settings = {
        username = {
          # format = "user: [$user]($style) ";
          show_always = true;
        };
        shlvl = {
          disabled = false;
          format = "$shlvl ▼ ";
          threshold = 4;
        };
      };
    };
    bash = {
      enable = true;
      bashrcExtra = ''
        flash-to(){
          if [ $(${pkgs.file}/bin/file $1 --mime-type -b) == "application/zstd" ]; then
            echo "Flashing zst using zstdcat | dd"
            ( set -x; ${pkgs.zstd}/bin/zstdcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
          elif [ $(${pkgs.file}/bin/file $2 --mime-type -b) == "application/xz" ]; then
            echo "Flashing xz using xzcat | dd"
            ( set -x; ${pkgs.xz}/bin/xzcat $1 | sudo dd of=$2 status=progress iflag=fullblock oflag=direct conv=fsync,noerror bs=64k )
          else
            echo "Flashing arbitrary file $1 to $2"
            sudo dd if=$1 of=$2 status=progress conv=sync,noerror bs=64k
          fi
        }

        export EDITOR=nvim

        mach-shell() {
          pypiApps=$(for arg; do printf '.%s' "$arg"; done)
          nix shell github:davhau/mach-nix#gen.pythonWith$pypiApps
        }

        # Makes `nix inate` as an alias of `nix shell`.
        nix() {
          case $1 in
            inate)
              shift
              command nix shell "$@"
              ;;
            *)
              command nix "$@";;
          esac
        }
        encryptFile() {
          cat $1 | ${lib.getExe pkgs.openssl} enc -aes256 -pbkdf2 -base64
        }
        decryptFile() {
          cat $1 | ${lib.getExe pkgs.openssl} aes-256-cbc -d -pbkdf2 -a
        }
      '';
      shellAliases = {
        gr = "cd $(git rev-parse --show-toplevel)";
        n = "nix-shell -p";
        r = "nix repl ${inputs.utils.lib.repl}";
        ssh = "env TERM=xterm-256color ssh";
        ipv6off = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=1 -w net.ipv6.conf.default.disable_ipv6=1 -w net.ipv6.conf.lo.disable_ipv6=1";
        ipv6on = "sudo sysctl -w net.ipv6.conf.all.disable_ipv6=0 -w net.ipv6.conf.default.disable_ipv6=0 -w net.ipv6.conf.lo.disable_ipv6=0";
      };
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.11";
}
