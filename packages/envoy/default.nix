{ pkgs, fetchzip }:
let
  yarn2nixSrc = fetchzip {
    url = https://github.com/moretea/yarn2nix/archive/master.zip;
    sha256 = "0d3naf94bvw1klmr1qnfggl9s1v3r80svxly7q4w39knxl5lafzl";
  };
  yarn2nixRepo = pkgs.callPackage yarn2nixSrc {};
  inherit (yarn2nixRepo) mkYarnPackage;
  envoy = fetchzip {
    url = "samrose";
    sha256 = "071avjxnm998wmlnc8x0nlg8c61c0rs2ksb3s77lai9v13vlff8w";
  };
in
  mkYarnPackage {
    src = envoy;
    packageJson = "${envoy}/package.json";
    yarnLock = "${envoy}/yarn.lock";
  }