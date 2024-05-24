{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userName = "TheStachelfisch";
    userEmail = "contact@thestachelfisch.dev";
    signing.key = "BAD3CD149697F0C7B922824FACA965618087B276";
    signing.signByDefault = true;
    extraConfig = {
      init.defaultbranch = "master";
    };
    lfs.enable = true;
  };
}
