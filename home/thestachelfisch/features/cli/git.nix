{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git-credential-oauth
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    signing.key = "BAD3CD149697F0C7B922824FACA965618087B276";
    signing.signByDefault = true;
    settings = {
      init.defaultbranch = "master";
      user = {
        name = "TheStachelfisch";
        email = "contact@thestachelfisch.dev";
      };
      credential = {
        helper = [ "libsecret" "cache --timeout 21600" "oauth" ];
      };
    };
    lfs.enable = true;
  };
}
