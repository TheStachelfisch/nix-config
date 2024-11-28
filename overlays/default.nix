{
  inputs,
  outputs,
}: {
  # From https://github.com/Misterio77/nix-config/blob/eb20842094f8963d9231ed8bf5e682ee83619f92/overlays/default.nix#L13
  # For every flake input, aliases 'pkgs.inputs.${flake}' to
  # 'inputs.${flake}.packages.${pkgs.system}' or
  # 'inputs.${flake}.legacyPackages.${pkgs.system}'
  flake-inputs = final: _: {
    inputs =
      builtins.mapAttrs (
        _: flake: let
          legacyPackages = (flake.legacyPackages or {}).${final.system} or {};
          packages = (flake.packages or {}).${final.system} or {};
        in
          if legacyPackages != {}
          then legacyPackages
          else packages
      )
      inputs;
  };

  # Adds pkgs.stable as an option
  stable = final: _: {
    stable = inputs.nixpkgs-stable.legacyPackages.${final.system};
  };

  # Adds additional custom packages
  additions = final: prev:
    import ../pkgs {pkgs = final;}
    // {
      vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins {};
    };

  # Modifies existing packages
  modifications = final: prev: {
    keepassxc = prev.keepassxc.overrideAttrs (oldAttrs: {
      src = prev.fetchFromGitHub {
        owner = "keepassxreboot";
        repo = "keepassxc";
        rev = "f4b91c17a9bcaf465382ee8f10e08005dd97cbf9";
        hash = "sha256-qexPsZwcTnHB6nminAc6P5xqde7yBi+DglzuwEZjzYM=";
      };
      buildInputs = oldAttrs.buildInputs ++ [final.keyutils];
    });
  };
}
