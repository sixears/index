{
  description = "Class for things that are indexable";

  inputs = {
    nixpkgs.url       = "github:nixos/nixpkgs/be44bf67"; # nixos-22.05 2022-10-15
    build-utils.url   = github:sixears/flake-build-utils/r1.0.0.13;

    more-unicode.url  = github:sixears/more-unicode/r0.0.17.11;
    tasty-plus.url    = github:sixears/tasty-plus/r1.5.2.21;
  };

  outputs = { self, nixpkgs, build-utils
            , more-unicode, tasty-plus }:
    build-utils.lib.hOutputs self nixpkgs "index" {
      deps = {
        inherit more-unicode tasty-plus;
      };
      ghc = p: p.ghc8107; # for tfmt
    };
}
