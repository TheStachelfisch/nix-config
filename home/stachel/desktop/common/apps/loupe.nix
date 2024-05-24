{ pkgs, ... }:
{
  home.packages = with pkgs; [ loupe ];
}
