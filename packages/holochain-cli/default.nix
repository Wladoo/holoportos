{ pkgs, stdenv, fetchurl, openssl }:

stdenv.mkDerivation {
  name = "holochain-cli";

  src = fetchurl {
    url = https://github.com/Holo-Host/holoportos/releases/download/conductor-0.0.11-alpha1/cli-0.0.11-alpha1-x86_64-generic-linux-gnu.tar.gz;
    sha256 = "1hpqkyk1gnjw3gl2ysd7y7fgkg08v7q0yhpkk2c74jgj4hmnqvp5";
  };
  #buildInputs = [
  #  openssl
  #];
  installPhase = ''
    mkdir -p $out/bin
    cp hc $out/bin
    patchelf --set-interpreter \
        ${stdenv.glibc}/lib/ld-linux-x86-64.so.2  $out/bin/holochain
    patchelf --set-rpath  ${stdenv.glibc}/lib $out/bin/holochain
    patchelf --set-rpath  ${openssl.out}/lib $out/bin/holochain
    #patchelf --add-needed ${openssl.out}/lib/libssl.so.1.0.0 $out/bin/holochain
    #patchelf --add-needed ${openssl.out}/lib/libcrypto.so.1.0.0 $out/bin/holochain
  '';
}
