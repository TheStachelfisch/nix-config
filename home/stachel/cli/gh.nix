{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    settings = {
      prompt = "enabled";
    };
  };
}
