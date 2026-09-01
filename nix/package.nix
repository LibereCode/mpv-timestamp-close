{
  stdenv,
  fuse,
  lib,
}:
let
  out_path = "$out/share/mpv/scripts";
in
stdenv.mkDerivation rec {
  pname = "mpv-mount-play";
  version = "dev"; # TODO: v0.0.X

  patchPhase = ''
    substituteInPlace mpv-mount-play.lua \
      --replace '"fusermount"' '"${fuse}/bin/fusermount"'
  '';

  installPhase = ''
    mkdir -p ${out_path}
    install -Dm755 ${pname}.lua ${out_path}/${pname}.lua
  '';

  meta = {
    description = "If ISO/image, mount. If directory, generate playlist file and play it.";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.eupl12 ];
  };
}
