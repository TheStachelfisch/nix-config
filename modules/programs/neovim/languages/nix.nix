{
  ...
}:
{
  flake.modules.homeManager.neovim = { ... }: {
    programs.nvf.settings.vim = {
      languages.nix = {
        enable = true;
        lsp = {
          servers = [
            "nixd"
          ];
        };
        format.type = [ "nixfmt" ];
      };

      lsp.servers = {
        nixd.settings.nixd = {
          nixpkgs.expr = "import (builtins.getFlake (builtins.toString ./.)).inputs.nixpkgs { }";
          options = {
            nixos = {
              expr = "(builtins.getFlake (builtins.toString /home/thestachelfisch/Workspace/personal/nix/nix-config)).nixosConfigurations.\"nixos-desktop\".options";
            };
            home-manager = {
              expr = "(builtins.getFlake (builtins.toString /home/thestachelfisch/Workspace/personal/nix/nix-config)).nixosConfigurations.\"nixos-desktop\".options.home-manager.users.type.getSubOptions []";
            };
            flake-parts = {
              expr = "(builtins.getFlake (builtins.toString ./.)).debug.options";
            };
            flake-parts-per-system = {
              expr = "(builtins.getFlake (builtins.toString ./.)).currentSystem.options";
            };
          };
        };
      };
    };
  };
}
