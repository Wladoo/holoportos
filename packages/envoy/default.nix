{ pkgs, fetchFromGitHub }:
let
  yarn2nixSrc = fetchFromGitHub {
    owner = "moretea";
    repo = "yarn2nix";
    rev = "3cc020e384ce2a439813adb7a0cc772a034d90bb";
    sha256 = "0h2kzdfiw43rbiiffpqq9lkhvdv8mgzz2w29pzrxgv8d39x67vr9";
  };
  yarn2nixRepo = pkgs.callPackage ./yarn2nixSrc {};
  inherit (yarn2nixRepo) mkYarnPackage;
  envoy = fetchFromGitHub {
    owner = "samrose";
    repo = "envoy";
    rev = "b86d72718195f6a878b7e0ac25fe59a8267751fe";
    sha256 = "1lqm9hr8mx3bbmwphplpq8m1z5a9rkzh6z39z7d9l7984514y7xq";
  };
in
  mkYarnPackage {
    src = envoy;
    packageJson = "${envoy}/package.json";
    yarnLock = "${envoy}/yarn.lock";
  }