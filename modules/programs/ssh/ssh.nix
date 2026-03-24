{
  flake.modules.nixos.ssh = {
    programs.ssh = {
      startAgent = true;
    };
  };
}
