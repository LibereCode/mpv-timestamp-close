{
  # stdenv,
  lib,
  mpvScripts,
}:
let
  out_path = "$out/share/mpv/scripts";
  base_name = "timestamp-close";
in
# stdenv.mkDerivation rec {
mpvScripts.buildLua {
  pname = "mpv-" + base_name;
  version = "0.0.2";

  src = ../../.;

  installPhase = ''
    mkdir -p ${out_path}
    install -Dm755 ${base_name}.lua ${out_path}/${base_name}.lua
  '';

  meta = {
    description = "Tiny script to keep track of video-close-timetamps";
    platforms = lib.platforms.linux;
    license = [ lib.licenses.eupl12 ];
  };
}
