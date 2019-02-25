{ buildRustPackage, postgresql, mysql, sqlite, openssl, rust, pkgconfig, fetchgit }:

buildRustPackage rec {
  name = "holochain-rust";
  version = "0.0.1";

  src =
  let
    source = fetchFromGitHub {
    owner = "holochain";
    repo = "holochain-rust";
    rev = "6d58e5b34321429ca8ef2337c225fb7e4b8d3159";
    sha256 = "12y03iy1g8wbjj3ydmdf87xg32124py2zjazg09pipz8szxy1dgn";
  };
  in
  runCommand "holochain-rust-src" {} ''
    cp -R ${source} $out
    chmod -R +w $out
  '';

  buildInputs = [
    pkgs.zeromq4
    pkgs.binutils
    pkgs.gcc
    pkgs.gnumake
    pkgs.openssl
    pkgs.pkgconfig
    pkgs.coreutils
    pkgs.cmake
    pkgs.python
    pkgs.libsodium
  ];
  useRealVendorConfig = true;
  cargoSha256 = "06nvsllzv4qkyv1213qa566dfanpfb44mhp4n19w64hjw45qpc83";
  #cargoSha256Version = 2;
  meta = with stdenv.lib; {
    description = "holochain-rust";
    homepage = https://github.com/holochain/holochain-rust;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };