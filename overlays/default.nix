{ inputs, outputs }:
{
  additions = final: prev: import ../pkgs { pkgs = final; } // {
    vimPlugins = prev.vimPlugins // final.callPackage ../pkgs/vim-plugins { };
  };

  modifications = final: prev: { };
}
