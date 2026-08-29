{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      git = {
        git-conflict = {
          enable = true;
        };
        gitsigns = {
          enable = true;
        };
        hunk-nvim = {
          enable = true;
        };
      };
    };
  };
}
