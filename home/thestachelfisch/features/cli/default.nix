{pkgs, inputs, ...}: {
  imports = [
    ./nushell
    ./nvim
    ./bat.nix
    ./git.nix
    ./gpg.nix
    ./direnv.nix
  ];

  # Smaller CLI tools
  home.packages = with pkgs; [
    wl-clipboard
  ];

  programs.nix-index = {
    enable = true;
    # package = pkgs.inputs.nix-index-database.nix-index-with-small-db;
    package = inputs.nix-index-database.packages.${pkgs.stdenv.system}.nix-index-with-small-db;
  };

  programs.nh = {
    enable = true;
    flake = "/home/thestachelfisch/Documents/nix-config";
  };
}
