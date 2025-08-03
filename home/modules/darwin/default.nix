{
  inputs,
  pkgs,
  ...
}: {
  home.file = {
    ".config/sketchybar" = {
      source = "${inputs.dotfiles}/sketchybar";
      recursive = true;
      onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    };

    # TODO: add sketchybar lua support (https://gist.github.com/gangjun06/00a309184adf4a86f5bc8a8a0ecc21dc)
    # home.file.".local/share/sketchybar_lua/sketchybar.so" = {
    #   source = "${pkgs.sbar-lua}/lib/sketchybar.so";
    #   onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    # };

    ".config/sketchybar/sketchybarrc" = {
      source = "${inputs.dotfiles}/sketchybar/sketchybarrc";
      executable = true;
      onChange = "${pkgs.sketchybar}/bin/sketchybar --reload";
    };
  };
}
