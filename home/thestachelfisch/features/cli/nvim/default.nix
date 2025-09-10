{pkgs, inputs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    extraPackages = with pkgs; [
      # Required for Treesitter
      gcc

      ripgrep
      fd
      fzf

      # Language Server
      lua-language-server # Lua
      nil # Nix
      zls_0_15
      vtsls # Typescript
      vue-language-server # Vue
      astro-language-server # Astro
      tailwindcss-language-server # Tailwind CSS
    ];
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };
}
