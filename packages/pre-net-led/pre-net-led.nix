{ stdenv, buildGoPackage, fetchFromGitHub }:
#with import <nixpkgs> {};
buildGoPackage rec {
  name    = "pre-net-led";


  goPackagePath = "github.com/samrose/pre-net-led";

  src = fetchFromGitHub {
    owner  = "samrose";
    repo   = "pre-net-led";
    rev    = "d64f55299205dd45d28934303695c79bc15ab4b1"; # untagged
    sha256 = "0fs3c0q3jqiv7349sr1zgjvp61xs7l9clqj8jfawh3aays03cng8";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "pre-net-led";
    homepage    = https://github.com/samrose/pre-net-led;
    license     = licenses.free;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}