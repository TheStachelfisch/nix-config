{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      binds.whichKey = {
        enable = true;
      };

      ui.borders.plugins.which-key = {
        enable = true;
        style = "rounded";
      };
    };
  };
}
