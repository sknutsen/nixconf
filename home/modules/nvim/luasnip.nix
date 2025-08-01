{
  config,
  inputs,
  pkgs,
  ...
}: {
  programs.nvf.settings.vim.snippets.luasnip = {
    enable = true;

    loaders = "require('luasnip.loaders.from_vscode').lazy_load()\nrequire('luasnip.loaders.from_snipmate').lazy_load()\n";

    customSnippets.snipmate = {
      nix = [
        {
          trigger = "mod";
          body = ''
            {inputs, pkgs, ...}:
            {
            }
          '';
        }
      ];
    };
  };
}
