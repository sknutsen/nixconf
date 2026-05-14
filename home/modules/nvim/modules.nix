{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim = {
    autocomplete = {
      blink-cmp = {
        enable = true;
        setupOpts.signature.enabled = true;
        setupOpts.cmdline.keymap.preset = "super-tab";
      };
    };

    autopairs.nvim-autopairs.enable = true;

    statusline = {
      lualine = {
        enable = true;
        theme = "catppuccin";
      };
    };

    telescope = {
      enable = true;
    };

    terminal = {
      toggleterm = {
        enable = true;

        lazygit = {
          enable = true;
          package = pkgs.lazygit;
          mappings.open = "<leader>lg";
        };
      };
    };

    treesitter = {
      enable = true;
      autotagHtml = true;
      grammars = with pkgs.vimPlugins.nvim-treesitter.builtGrammars; [
        kdl
        regex
        tree-sitter-templ
      ];
    };

    ui = {
      noice = {
        enable = true;
      };
    };

    utility = {
      oil-nvim = {
        enable = true;
        setupOpts = {
          view_options = {
            show_hidden = true;
          };
        };
      };

      snacks-nvim = {
        enable = true;

        setupOpts = {
          explorer = {
            enabled = true;
          };

          picker = {
            sources = {
              explorer = {
                layout = {
                  layout = {
                    # position = "right";
                  };
                };
              };

              files = {
                cmd = "rg";
              };
            };
          };

          project = {
            dirs = [
              "~/code"
            ];
          };
        };
      };
    };

    visuals = {
      nvim-scrollbar.enable = false;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;

      highlight-undo.enable = true;
      indent-blankline.enable = true;

      # Fun
      cellular-automaton.enable = false;
    };
  };
}
