{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim.languages.rust = {
      enable = true;
      lsp.enable = false;
      extensions = {
        crates-nvim.enable = true;
        rustaceanvim.enable = true;
      };
    };
  };
}
