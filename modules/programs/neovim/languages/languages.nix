{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim.languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
    };
  };
}
