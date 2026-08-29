{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      visuals = {
        blink-indent.enable = true;
        fidget-nvim.enable = true;
        nvim-web-devicons.enable = true;
      };
      mini.icons.enable = true;
      notify.nvim-notify.enable = true;
    };
  };
}
