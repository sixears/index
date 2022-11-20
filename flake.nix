{
  description = "Class for things that are indexable";

  inputs = {
    nixpkgs.url       = github:nixos/nixpkgs/be44bf67; # nixos-22.05 2022-10-15
    build-utils.url   = github:sixears/flake-build-utils/r1.0.0.13;

    more-unicode.url  = github:sixears/more-unicode/r0.0.17.12;
    tasty-plus.url    = github:sixears/tasty-plus/r1.5.2.24;
  };

  outputs = { self, nixpkgs, build-utils
            , more-unicode, tasty-plus }:
    build-utils.lib.hOutputs self nixpkgs "index" {
      ghc = p: p.ghc8107; # for tfmt
      callPackage = { mkDerivation, lib, mapPkg, system
                    , base, base-unicode-symbols, hashable, optparse-applicative
                    , safe, tasty, tasty-hunit, unordered-containers
                    }:
        mkDerivation {
          pname = "index";
          version = "1.0.1.26";
          src = ./.;
          libraryHaskellDepends = [
            base base-unicode-symbols hashable safe tasty tasty-hunit
            unordered-containers
          ] ++ mapPkg [ more-unicode tasty-plus ];
          testHaskellDepends = [
            base base-unicode-symbols optparse-applicative
          ] ++ mapPkg [ more-unicode tasty-plus ];
          description = "Class for things that are indexable";
          license = lib.licenses.mit;
        };
    };
}
