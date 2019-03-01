{ stdenv, lib, qt5, saneBackends, makeWrapper, fetchurl }:
stdenv.mkDerivation rec {
  name = "master-pdf-editor-${version}";
  version = "4.3.10";

  src = fetchurl {
    url = https://gist.githubusercontent.com/samrose/caba3e3556e11151bdc90f0b0fb567a9/raw/a46de503498dbe1bbed275168e3a6db459f235f0/empty-container.toml;
    sha256 = "1g8m78qzdnbp3vp8sd5qlpa2p1r5fmav28yjsrf65k4wfkn62dr4";
  };
  sourceRoot = ".";

  buildPhase = ":";   # nothing to build

  installPhase = ''
    mkdir -p $out/lib
    # symlink the binary to bin/
    ln -s $out/opt/master-pdf-editor-4/masterpdfeditor4 $out/bin/masterpdfeditor4
  '';
  preFixup = let
    # we prepare our library path in the let clause to avoid it become part of the input of mkDerivation
    libPath = lib.makeLibraryPath [
      qt5.qtbase        # libQt5PrintSupport.so.5
      qt5.qtsvg         # libQt5Svg.so.5
      stdenv.cc.cc.lib  # libstdc++.so.6
      saneBackends      # libsane.so.1
    ];
  in ''
    patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath "${libPath}" \
      $out/opt/master-pdf-editor-4/masterpdfeditor4
  '';

  meta = with stdenv.lib; {
    homepage = https://code-industry.net/masterpdfeditor/;
    description = "a multifunctional PDF Editor";
    license = licenses.proprietary;
    platforms = platforms.linux;
    maintainers = [ your_name ];
  };
}



{ stdenv, pkgs, lib, config, fetchurl,
    conductor-config ? fetchurl {
      url = https://gist.githubusercontent.com/samrose/caba3e3556e11151bdc90f0b0fb567a9/raw/a46de503498dbe1bbed275168e3a6db459f235f0/empty-container.toml;
      sha256 = "1g8m78qzdnbp3vp8sd5qlpa2p1r5fmav28yjsrf65k4wfkn62dr4";
    },
    ... }:

{
  conductor-config = conductor-config;

}
