{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [
  ];

  programs.nvf = {
    enable = true;
    # your settings need to go into the settings attribute set
    # most settings are documented in the appendix
    settings = {
      vim = {
        viAlias = true;
        vimAlias = true;
        package = pkgs.neovim-unwrapped;

        options = {
          shiftwidth = 2;
          tabstop = 2;
        };

        autocomplete = {
          blink-cmp = {
            enable = true;
            setupOpts.signature.enabled = true;
            setupOpts.cmdline.keymap.preset = "super-tab";
          };
        };

        clipboard = {
          enable = true;
          registers = "unnamed,unnamedplus";
        };

        spellcheck = {
          enable = true;
        };

        lsp = {
          enable = true;
          formatOnSave = true;
          lspkind.enable = true;
          lightbulb.enable = true;
          lspsaga.enable = false;
          trouble.enable = true;
          lspSignature.enable = false;
          otter-nvim.enable = false;
          nvim-docs-view.enable = false;
          # lspconfig = {
          #   enable = true;
          #   sources = {
          #     templ_ls = {};
          #   };
          # };
          servers = {
            htmx = {};
            templ = {};
          };
        };

        # This section does not include a comprehensive list of available language modules.
        # To list all available language module options, please visit the nvf manual.
        languages = {
          enableFormat = true;
          enableTreesitter = true;
          enableExtraDiagnostics = true;

          assembly.enable = false;
          astro.enable = false;
          bash.enable = true;
          clang.enable = true;
          csharp.enable = false;
          css.enable = true;
          dart.enable = false;
          elixir.enable = false;
          fsharp.enable = false;
          gleam.enable = false;
          go = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          haskell.enable = false;
          html.enable = true;
          java.enable = false;
          julia.enable = false;
          kotlin.enable = false;
          lua.enable = true;
          markdown.enable = true;
          nix = {
            enable = true;
            format.enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };
          nu.enable = false;
          ocaml.enable = false;
          python.enable = true;
          r.enable = false;
          ruby.enable = false;
          rust = {
            enable = false;
            crates.enable = false;
          };
          scala.enable = false;
          sql.enable = true;
          svelte.enable = false;
          tailwind.enable = false;
          ts.enable = true;
          typst.enable = false;
          vala.enable = false;
          yaml.enable = true;
          zig = {
            enable = true;
            lsp.enable = true;
            treesitter.enable = true;
          };

          # Nim LSP is broken on Darwin and therefore
          # should be disabled by default. Users may still enable
          # `vim.languages.vim` to enable it, this does not restrict
          # that.
          # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
          nim.enable = false;
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

        statusline = {
          lualine = {
            enable = true;
            theme = "catppuccin";
          };
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

        theme = {
          enable = true;
          name = "catppuccin";
          style = "mocha";
          transparent = false;
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
        };

        autopairs.nvim-autopairs.enable = true;

        # autocomplete.nvim-cmp.enable = true;
        snippets.luasnip.enable = true;

        telescope = {
          enable = true;
        };

        keymaps = [
          {
            key = "-";
            mode = "n";
            action = "<CMD>Oil<CR>";
          }
        ];
      };
    };
  };
}
