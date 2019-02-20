{ stdenv, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  name = "hello_world";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "hello_world";
    rev = "be6efdbdcb5dd10bf9da860a0882b34f94aac68a";
    sha256 = "0blfx8m0sc4mlbmbw9m0z1sybn10sxpjqw6bhhnans86ywybgkaa";
  };
  #buildInputs = [ holo-rust ];
  cargoSha256 = "0sjjj9z1dhilhpc8pq4154czrb79z9cm044jvn75kxcjv6v5l2m5";

  meta = with stdenv.lib; {
    description = "a test";
    homepage = https://github.com/samrose/hello_world;
    license = licenses.unlicense;
    maintainers = [ maintainers.tailhook ];
    platforms = platforms.all;
  };
}
