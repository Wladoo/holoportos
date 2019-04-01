{ stdenv, appimage-run, fetchurl }:
#with import <nixpkgs> {};
  stdenv.mkDerivation rec {
  name = "n3h-0.0.7-alpha2-linux-x64";

  src = fetchurl {
    url = https://github.com/holochain/n3h/releases/download/adhoc-2019-03-21/n3h-0.0.7-alpha2-linux-x64.AppImage;
    sha256 = "09l1vnz1yc21jp8sxzw79bgmvc5hr1vk787lbhblp2fjd7v2rpas";
  };

  buildInputs = [ appimage-run ];

  unpackPhase = ":";

  installPhase = ''
    mkdir -p $out/{bin,share}
    cp $src $out/share/n3h-0.0.7-alpha2-linux-x64.AppImage
    echo "#!/bin/sh" > $out/bin/n3h-0.0.7-alpha2-linux-x64
    echo "${appimage-run}/bin/appimage-run $out/share/n3h-0.0.7-alpha2-linux-x64.AppImage" >> $out/bin/n3h-0.0.7-alpha2-linux-x64
    chmod +x $out/bin/n3h-0.0.7-alpha2-linux-x64 $out/share/n3h-0.0.7-alpha2-linux-x64.AppImage
  '';

  meta = with stdenv.lib; {
    description = "n3h AppImage";
    longDescription = ''
      Running n3h as an AppImage binary
    '';
    homepage = https://holo.host;
    license = licenses.mit;
    maintainers = with maintainers; [ samrose ];
    platforms = [ "x86_64-linux" ];
  };
}
