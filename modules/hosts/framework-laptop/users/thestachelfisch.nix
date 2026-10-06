{
  inputs,
  ...
}:
{
  flake.modules.nixos.framework-laptop =
    { pkgs, ... }:
    {
      imports = with inputs.self.modules.nixos; [
        thestachelfisch
      ];

      home-manager.users.thestachelfisch = {
        imports = with inputs.self.modules.homeManager; [
          thestachelfisch
          system-desktop
        ];

        home.packages = with pkgs.unstable; [
          spotify
          orca-slicer

          # TODO: Move this into an office module
          libreoffice-qt-fresh
          vista-fonts
          poppins
        ];
      };
    };
}
