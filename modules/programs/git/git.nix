{
  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;
      settings = {
        init.defaultbranch = "master";
        credential = {
          helper = [
            "libsecret"
            "cache --timeout 21600"
            "oauth"
          ];
        };
      };
    };
  };
}
