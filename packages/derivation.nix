{ pkgs, stdenv, buildRustPackage, neon, openssl, rust, pkgconfig, fetchFromGitHub, runCommand }:
let
  nodejs-8_13 = pkgs.nodejs-8_x.overrideAttrs(oldAttrs: rec {
    name = "nodejs-${version}";
    version = "8.13.0";
    src = pkgs.fetchurl {
      url = "https://nodejs.org/dist/v${version}/node-v${version}.tar.xz";
      sha256 = "1qidcj4smxsz3pmamg3czgk6hlbw71yw537h2jfk7iinlds99a9a";
    };
  });
in
buildRustPackage rec {
  name = "holochain-rust";
  version = "0.0.1";

  src =
  let
    source = fetchFromGitHub {
    owner = "samrose";
    repo = "conductor";
    rev = "126345d7ac46a2a588171560fc573eedb245b25e";
    sha256 = "0qf5dc93gvarvdzzxppb5sprw4w4advrdczglxlcnfpr52bmrnf2";
  };
  in
  runCommand "conductor-src" {} ''
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
    nodejs-8_13
    neon
  ];
  useRealVendorConfig = true;
  cargoSha256 = "0jawyvs4182jwxj7f4ay0jg1r9ws95r0g3qqd87hn4ryyjn9k697";
  #cargoSha256Version = 2;
  meta = with stdenv.lib; {
    description = "holochain-rust";
    homepage = https://github.com/holochain/holochain-rust;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
