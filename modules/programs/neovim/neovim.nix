{ inputs, ... }: {
  flake.modules.homeManager.neovim =
    { pkgs, ... }:
    {
      imports = [ inputs.nvf.homeManagerModules.default ];

      home.sessionVariables = {
        EDITOR = "nvim";
        VISUAL = "nvim";
      };

      programs.nvf = {
        enable = true;
        settings.vim = {
          viAlias = true;
          vimAlias = true;
          syntaxHighlighting = true;
          enableLuaLoader = true;
          vendoredKeymaps.enable = false;
          undoFile.enable = true;

          options = {
            autoindent = true;
            list = true; # Show hidden characters
            confirm = true; # Confirm question on operations that would normally fail
            scrolloff = 3; # Minimum lines to keep above and below cursor
            shiftround = true; # Round indent to multiple of shiftwidth
            signcolumn = "yes";
            splitright = true; # Always open splits to the right
            autoread = true;
            foldlevel = 99;

            shiftwidth = 2;
            tabstop = 2;
            wrap = false;
            expandtab = true;
          };

          clipboard = {
            enable = true;
            registers = "unnamedplus";
            providers.wl-copy.enable = true;
          };

          ui = {
            borders = {
              enable = true;
            };
          };

          treesitter = {
            enable = true;
            fold = true;
            context.enable = true;
          };

          lsp = {
            enable = true;
            formatOnSave = true;
          };
        };
      };
    };
}
