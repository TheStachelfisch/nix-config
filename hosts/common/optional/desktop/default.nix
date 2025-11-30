{ pkgs, ... }: {
  fonts.fontDir.enable = true;
  documentation = {
    dev.enable = true;
    man = {
      man-db.enable = false;
      mandoc.enable = true;
    };
  };

  fonts.packages = with pkgs; [
    maple-mono.NF-unhinted
  ];

  services.printing = {
    enable = true;
    drivers = with pkgs; [
      cups-filters
      cups-browsed
    ];
  };
}
