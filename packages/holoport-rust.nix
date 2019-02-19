{ stdenv, fetchFromGitHub, rustPlatform }:
rustPlatform.buildRustPackage rec {
  name = "hello_world";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "samrose";
    repo = "hello_world";
    rev = "082775d0388552e32b644a1e3da8755a5f5e8c6a";
    sha256 = "1jhkhpyh8g0ja6rr8bffphybhz53m7fav6r8pndv94msjdjdc7f6";
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
