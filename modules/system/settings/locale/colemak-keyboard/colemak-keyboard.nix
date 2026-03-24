{
  flake.modules.nixos.colemak-keyboard = {
    services.xserver.xkb = {
      layout = "EurKEY_Colemak-DH";
      extraLayouts."EurKEY_Colemak-DH" = {
        description = "EurKEY Colemak-DH layout";
        languages = ["eng" "ger"];
        symbolsFile = ./EurKeyXKB;
      };
    };

    console.useXkbConfig = true;
  };
}
