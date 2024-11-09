{
  inputs,
  outputs,
}: {
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
