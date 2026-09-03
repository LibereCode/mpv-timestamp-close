{ ... }:
{
  perSystem =
    {
      pkgs,
      self',
      config,
      ...
    }:
    {
      packages = {
        mpv-timestamp-close = pkgs.callPackage ./mpv-timestamp-close.nix { };

        mpv-w-script = pkgs.mpv.override { scripts = [ config.packages.default ]; };

        default = self'.packages.mpv-timestamp-close;
      };
    };
}
