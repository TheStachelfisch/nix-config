{ inputs, outputs }:
{
  additions = final: prev: import ../pkgs { pkgs = final; } // {
    vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins { };
  };

  modifications = final: prev: {
    keepassxc = prev.keepassxc.overrideAttrs (oldAttrs: rec {
      version = "2.7.8";
      src = prev.fetchFromGitHub {
        owner = "keepassxreboot";
        repo = "keepassx";
        rev = version;
        hash = "sha256-Gb5/CPhn/phVVvz9BFv7rb12n/P3rPNl5r2gA+E5b0o=";
      };

      buildInputs = oldAttrs.buildInputs ++ [ final.keyutils ];
    });
  }; 
}
