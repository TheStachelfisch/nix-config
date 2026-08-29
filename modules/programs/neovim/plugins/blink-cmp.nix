{
  flake.modules.homeManager.neovim = {
    programs.nvf.settings.vim = {
      autocomplete.blink-cmp = {
        enable = true;
        setupOpts.keymap.preset = "default";
      };
    };
  };
}
