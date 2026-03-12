{ pkgs, ... }: {
  fonts = {
    fontDir.enable = true;
    fontconfig = {
      enable = true;
      antialias = true;
      subpixel ={
        rgba = "none";
      };

      hinting = {
        enable = true;
        autohint = false;
        style = "slight";
      };

      allowBitmaps = false;

      defaultFonts = {
        monospace = [ "Maple Mono NF" ];
      };
    };
  };

  documentation = {
    dev.enable = true;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
    raleway
    vista-fonts
    corefonts
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };

  programs.ausweisapp = {
    enable = true;
    openFirewall = true;
  };
}
