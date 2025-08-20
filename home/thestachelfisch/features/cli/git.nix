{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-credential-oauth
  ];

  programs.git = {
    enable = true;
    package = pkgs.git.override { withLibsecret = true; };
    userName = "TheStachelfisch";
    userEmail = "contact@thestachelfisch.dev";
    signing.key = "BAD3CD149697F0C7B922824FACA965618087B276";
    signing.signByDefault = true;
    extraConfig = {
      init.defaultbranch = "master";
      credential = {
        helper = [ "libsecret" "cache --timeout 21600" "oauth" ];
      };
    };
    lfs.enable = true;
  };
}
