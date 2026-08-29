{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      fzf-lua = {
        enable = true;
        setupOpts = {
          fzf_colors = true;
        };
      };

      keymaps = [
        {
          key = "<leader><space>";
          desc = "Find Files (Root Dir)";
          mode = "n";
          action = ":FzfLua files<CR>";
        }
        {
          key = "<leader>/";
          desc = "Grep (Root Dir)";
          mode = "n";
          action = ":FzfLua live_grep<CR>";
        }
        {
          key = "<leader>,";
          desc = "Switch Buffers";
          mode = "n";
          action = ":FzfLua buffers sort_mru=ture sort_lastused=true<CR>";
        }
      ];
    };
  };
}
