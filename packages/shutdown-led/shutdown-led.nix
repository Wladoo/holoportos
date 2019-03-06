{ stdenv, buildGoPackage, fetchFromGitHub }:

buildGoPackage rec {
  name    = "shutdown-led";


  goPackagePath = "github.com/samrose/shutdown-led";

  src = fetchFromGitHub {
    owner  = "samrose";
    repo   = "shutdown-led";
    rev    = "e58eae95635686e1d10553dddf1f5dff21243976"; # untagged
    sha256 = "1wcikbfd4z0bznb29zmhlsi49aniszrz1ar6y029gg59l6vbbzx8";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "shutdown-led";
    homepage    = https://github.com/samrose/shutdown-led;
    license     = licenses.free;
    platforms   = platforms.unix;
    maintainers = [ maintainers.samrose ];
  };
}