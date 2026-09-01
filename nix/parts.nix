{ inputs, ... }:
{
  systems = [
    "x86_64-linux"
    #NOTE: need testing for other systems
  ];

  perSystem =
    {
      pkgs,
      self',
      ...
    }:
    {
      packages.mpv-timestamp-close = pkgs.callPackage ./package.nix { };
      packages.default = self'.packages.mpv-timestamp-close;
    };
}
