{
  isWSL,
  isDarwin,
  inputs,
  ...
}: {
  config,
  lib,
  pkgs,
  ...
}: let
  # JaKooLit/dotfiles GTK+Qt trees fight zdesktop.applySystemTheme (named
  # theme, extraCss, color-scheme, qt.platformTheme=gtk3). Keep them only
  # when zdesktop is not actually styling the session.
  zdesktopStyling =
    config.zdesktop.applySystemTheme
    && (config.programs.zdkhypr.enable || config.programs.zdkshell.enable);
in {
  imports =
    [
      inputs.nvf.homeManagerModules.default
      inputs.zdesktop.homeManagerModules.default
      inputs.zen-browser.homeModules.twilight

      ../../modules/dev
      ../../modules/nvim
      (import ../../modules/shell {inherit inputs pkgs lib;})
      ../../modules/utils
      ../../modules/vcs
    ]
    ++ lib.optional (!isWSL && !isDarwin) (import ./gui.nix {inherit inputs pkgs lib;})
    ++ lib.optional isDarwin ../../modules/darwin;

  home = {
    # Home Manager needs a bit of information about you and the paths it should
    # manage.
    username = "zdk";

    # The home.packages option allows you to install Nix packages into your
    # environment.
    packages = with pkgs; [
      # # It is sometimes useful to fine-tune packages, for example, by applying
      # # overrides. You can do that directly here, just don't forget the
      # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
      # # fonts?
      # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

      # # You can also create simple shell scripts directly inside your
      # # configuration. For example, this adds a command 'my-hello' to your
      # # environment:
      # (pkgs.writeShellScriptBin "my-hello" ''
      #   echo "Hello, ${config.home.username}!"
      # '')
      age
      bat
      cursor-cli
      dig
      eza
      fluxcd
      gh
      htop
      jq
      kubectl
      lazygit
      ripgrep
      sops
      wireguard-tools
      zsh
    ];

    # Home Manager is pretty good at managing dotfiles. The primary way to manage
    # plain files is through 'home.file'.
    file = {
      # # Building this configuration will create a copy of 'dotfiles/screenrc' in
      # # the Nix store. Activating the configuration will then make '~/.screenrc' a
      # # symlink to the Nix store copy.
      # ".screenrc".source = dotfiles/screenrc;

      # # You can also set the file content immediately.
      # ".gradle/gradle.properties".text = ''
      #   org.gradle.console=verbose
      #   org.gradle.daemon.idletimeout=3600000
      # '';
      ".config/gtk-3.0" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/gtk/gtk-3.0";
      };
      ".config/gtk-4.0" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/gtk/gtk-4.0";
      };
      ".config/kglobalshortcutsrc".source = "${inputs.dotfiles}/kde/kglobalshortcutsrc";
      ".config/kvantum" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/kvantum";
      };
      ".config/lazydocker".source = "${inputs.dotfiles}/lazydocker";
      ".config/lazygit".source = "${inputs.dotfiles}/lazygit";
      ".config/qt5ct" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/qt/qt5ct";
      };
      ".config/qt6ct" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/qt/qt6ct";
      };
      ".config/rofi" = lib.mkIf (!zdesktopStyling) {
        source = "${inputs.dotfiles}/rofi";
      };
      # ".config/sketchybar" = {
      # source = "${inputs.dotfiles}/sketchybar";
      # recursive = true;
      # onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
      # };

      # ".config/sketchybar/sketchybarrc" = {
      # source = "${inputs.dotfiles}/sketchybar/sketchybarrc";
      # executable = true;
      # onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
      # };
      #
      # Zsh
      "zsh".source = "${inputs.dotfiles}/zsh/zsh";
      ".zprofile".source = "${inputs.dotfiles}/zsh/.zprofile";
      ".zshenv".source = "${inputs.dotfiles}/zsh/.zshenv";
      ".zshrc".source = "${inputs.dotfiles}/zsh/.zshrc";
      ".zshrc.zni".source = "${inputs.dotfiles}/zsh/.zshrc.zni";
    };

    # Home Manager can also manage your environment variables through
    # 'home.sessionVariables'. These will be explicitly sourced when using a
    # shell provided by Home Manager.
    sessionVariables = {
      EDITOR = "nvim";
      NH_DARWIN_FLAKE = "/Users/zdk/.nixconf";
      NH_HOME_FLAKE = "/home/zdk/.config/home-manager";
      NH_OS_FLAKE = "/home/zdk/.nixconf";
    };

    shell = {
      enableZshIntegration = false;
      enableFishIntegration = true;
    };

    # This value determines the Home Manager release that your configuration is
    # compatible with. This helps avoid breakage when a new Home Manager release
    # introduces backwards incompatible changes.
    #
    # You should not change this value, even if you update Home Manager. If you do
    # want to update the value, then make sure to first check the Home Manager
    # release notes.
    stateVersion = "24.05"; # Please read the comment before changing.

    # Old gens linked gtk/rofi as store directories. zdesktop and programs.rofi
    # now write files inside those paths; unlink the dirs before HM tries to
    # backup/replace files on a read-only store symlink.
    activation.unpinZdesktopThemeDirs = lib.mkIf zdesktopStyling (
      lib.hm.dag.entryBefore ["checkLinkTargets"] ''
        for dir in gtk-3.0 gtk-4.0 rofi kvantum qt5ct qt6ct; do
          path="${config.xdg.configHome}/$dir"
          if [ -L "$path" ]; then
            run rm -f "$path"
          fi
        done
      ''
    );

    # dotnet workload install expects a login user (not activate-as-root); darwin/remorse only (.NET MAUI).
    activation.dotnetMauiWorkloads =
      lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      (lib.hm.dag.entryAfter ["installPackages"] ''
        run echo "Installing .NET MAUI workloads…"
        run ${pkgs.dotnetCorePackages.sdk_10_0}/bin/dotnet workload install maui maui-ios maui-android
      '');
  };

  programs = {
    direnv = {
      enable = true;
    };

    lazydocker = {
      enable = true;
    };

    lazygit = {
      enable = true;
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;
      settings = builtins.fromTOML (builtins.readFile "${inputs.dotfiles}/starship/starship.toml");
    };

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableFishIntegration = true;

      settings = builtins.fromTOML ''
        [mgr]
        show_hidden = true
      '';

      shellWrapperName = "y";
    };
  };

  services = {
    syncthing = {
      enable = true;
      guiAddress = "127.0.0.1:8384";
    };
  };

  xdg = {
    enable = true;
    configFile = {
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
