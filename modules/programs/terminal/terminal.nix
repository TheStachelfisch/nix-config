{
  flake.modules.homeManager.terminal =
    { pkgs, ... }:
    {
      programs.foot = {
        enable = true;
        package = pkgs.unstable.foot;
        settings = {
          main = {
            font = "Maple Mono NF:size=10";
            resize-delay-ms = 0;
            resize-by-cells = "no";
            resize-keep-grid = "no";
          };
          mouse = {
            hide-when-typing = "yes";
          };
          csd = {
            preferred = "server";
            size = 0;
            border-width = 0;
          };
          colors-dark = {
            background = "000000";
            foreground = "f2f4f8";

            selection-background = "2a2a2a";
            selection-foreground = "f2f4f8";
            urls = "25be6a";

            ## Normal/Regular colors (Ansi 0-7)
            regular0 = "282828";
            regular1 = "ee5396";
            regular2 = "25be6a";
            regular3 = "08bdba";
            regular4 = "78a9ff";
            regular5 = "be95ff";
            regular6 = "33b1ff";
            regular7 = "dfdfe0";

            ## Bright colors (Ansi 8-15)
            bright0 = "484848";
            bright1 = "f16da6";
            bright2 = "46c880";
            bright3 = "2dc7c4";
            bright4 = "8cb6ff";
            bright5 = "c8a5ff";
            bright6 = "52bdff";
            bright7 = "e4e4e5";

            ## Upstream Extended Canvas Tokens
            "16" = "3ddbd9";
            "17" = "ff7eb6";

            ## Explicit Carbonfox Dim Alternates (Generates perfect code-folding contrast)
            dim0 = "1c1c1c";
            dim1 = "b33e71";
            dim2 = "1c8f50";
            dim3 = "068e8c";
            dim4 = "5a7fbf";
            dim5 = "8f70bf";
            dim6 = "2685bf";
            dim7 = "a7a7a8";

            cursor = "161616 f2f4f8";
          };
        };
      };

      home.packages = with pkgs; [
        maple-mono.NF-unhinted
      ];
    };
}
