{
  inputs,
  ...
}:
{
  flake.modules.homeManager.system-minimal =
    {
      config,
      ...
    }:
    {
      home.homeDirectory = "/home/${config.home.username}";
      home.stateVersion = "25.11";
    };
}
