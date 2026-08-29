{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim.languages.nix = {
      enable = true;
      format.type = [ "nixfmt" ];
    };
  };
}
