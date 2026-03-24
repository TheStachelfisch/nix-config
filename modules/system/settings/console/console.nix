{
  flake.modules.nixos.console = {
    console = {
      useXkbConfig = true;
      earlySetup = true;
    };
  };
}
