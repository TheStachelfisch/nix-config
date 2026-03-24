{ ... }:
{
  perSystem =
    { pkgs, inputs, ... }:
    {
      formatter = pkgs.nixfmt-tree;
    };
}
