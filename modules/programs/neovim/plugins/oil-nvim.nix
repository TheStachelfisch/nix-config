{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      utility.oil-nvim = {
        enable = true;
        gitStatus.enable = true;
        setupOpts = {
          float = {
            max_height = 0.8;
            max_width = 0.8;
          };
        };
      };

      keymaps = [
        {
          key = "<leader>-";
          mode = "n";
          action = ":Oil --float<CR>";
          desc = "Open Oil";
        }
      ];
    };
  };
}
