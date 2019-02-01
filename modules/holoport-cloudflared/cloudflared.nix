#with import <nixpkgs> {}; #for standalone use
{ stdenv, buildGoPackage, fetchFromGitHub }:
buildGoPackage rec {
  name    = "cloudflared-${version}";
  version = "2019.1.0";
  goPackagePath = "github.com/cloudflare/cloudflared";

  src = fetchFromGitHub {
    owner  = "cloudflare";
    repo   = "cloudflared";
    rev    = "6a331b13ba671398be0db9659eac6ea5cfcda827"; 
    sha256 = "14rrqv9vv09rvrxg0vhclyzkgsh1lkxwqshc575njs846qxjqwkd";
  };

  goDeps = ./deps.nix;

  meta = with stdenv.lib; {
    description = "CloudFlare Argo Tunnel daemon (and DNS-over-HTTPS client)";
    homepage    = https://www.cloudflare.com/products/argo-tunnel;
    license     = licenses.notfree;
    platforms   = platforms.unix;
    maintainers = [ maintainers.thoughtpolice ];
  };
}
