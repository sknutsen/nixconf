{ config, pkgs, inputs, ... }:

{
	programs.neovim = {
		enable = true;
		
		viAlias = true;
		vimAlias = true;
		vimDiffAlias = true;
	};
}