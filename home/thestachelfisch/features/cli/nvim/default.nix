{pkgs, ...}: {
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = true;
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
      zls_0_15 # ZIG
      vtsls # Typescript
      vue-language-server # Vue
      astro-language-server # Astro
      tailwindcss-language-server # Tailwind CSS
      basedpyright # Python type checker
      ruff # Python LSP
      phpactor # PHP LSP
      prisma-language-server # Prisma
      vscode-langservers-extracted # CSS, HTML, JSON etc.
      clang-tools # clangd
      rust-analyzer # Rust

      # Formatters
      stylua # Lua
      php84Packages.php-cs-fixer # PHP formatter

      # Linters
      biome # Web formatter & linter
      # sqlfluff # SQL linter & formatter
      statix # Nix
      # php84Packages.php-codesniffer
    ];
  };

  # xdg.configFile.nvim = {
  #   source = ./config;
  #   recursive = true;
  # };
}
