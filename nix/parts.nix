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
      packages.mpv-CHANGE_ME = pkgs.callPackage ./nix/package.nix { };
      packages.default = self'.packages.mpv-mount-play;
    };
}
