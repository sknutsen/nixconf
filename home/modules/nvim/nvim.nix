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
          mousescroll = "ver:1";
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

          presets = {
            superhtml.enable = true;
            tailwindcss-language-server.enable = false;
          };

          servers = {
            "*" = {
              root_markers = [".git"];
              capabilities = {
                textDocument = {
                  semanticTokens = {
                    multilineTokenSupport = true;
                  };
                };
              };
            };

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
          qml = {
            enable = true;
          };
          r.enable = false;
          ruby.enable = false;
          rust = {
            enable = false;
            extensions.crates-nvim.enable = false;
          };
          scala.enable = false;
          sql.enable = true;
          svelte.enable = false;
          typescript.enable = true;
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

        # vim.theme is applied by zdesktop (mkDefault from zdesktop.theme).

        keymaps = [
          {
            key = "-";
            mode = "n";
            action = "<CMD>Oil<CR>";
          }
          {
            key = "<leader>fe";
            mode = "n";
            lua = true;
            action = "function() Snacks.explorer.open() end";
          }
        ];
      };
    };
  };
}
