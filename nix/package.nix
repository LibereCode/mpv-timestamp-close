{
  stdenv,
  lib,
}:
let
  out_path = "$out/share/mpv/scripts";
in
stdenv.mkDerivation rec {
  pname = "mpv-timestamp-close";
  version = "2026-09-01"; # TODO: v0.0.X

  installPhase = ''
    mkdir -p ${out_path}
    install -Dm755 ${pname}.lua ${out_path}/${pname}.lua
  '';

  meta = {
    description = "Tiny script to keep track of video-close-timetamps";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.eupl12 ];
  };
}
