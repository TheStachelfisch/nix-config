{
  inputs,
  ...
}:
{
  flake.modules.nixos.nixos-desktop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        thestachelfisch
      ];

      fonts.fontconfig = {
        enable = true;
        hinting = {
          enable = true;
          style = "slight";
        };
        subpixel = {
          rgba = "none";
        };
      };

      home-manager.users.thestachelfisch = {
        imports = with inputs.self.modules.homeManager; [
          thestachelfisch
          system-desktop
        ];

        home.packages = with pkgs.unstable; [
          spotify
          cemu
          eden
          orca-slicer

          jetbrains.rider
          dotnet-sdk_10
          dotnet-ef

          # TODO: Move this into an office module
          libreoffice-qt-fresh
          vista-fonts
          poppins

          bottles
          mangohud
          heroic

          moonlight-qt

          (prismlauncher.override {
            jdks = [
              graalvmPackages.graalvm-ce
              openjdk17
            ];
          })
        ];

        # fonts.fontconfig = {
        #   hinting = "slight";
        #   antialiasing = true;
        #   subpixelRendering = "none";
        # };

        xdg.configFile."fontconfig/conf.d/10-hm-fonts.conf".force = true;
      };
    };
}
