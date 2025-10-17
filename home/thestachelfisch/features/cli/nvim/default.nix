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
      tree-sitter

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
      basedpyright # Python type checker
      ruff # Python LSP
      phpactor # PHP LSP
    ];
  };

  xdg.configFile.nvim = {
    source = ./config;
    recursive = true;
  };
}
