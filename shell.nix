{ nixpkgs ? import <nixpkgs> {}, compiler ? "default", doBenchmark ? false }:

let

  inherit (nixpkgs) pkgs;

  f = { mkDerivation, aeson, base, http-client, http-client-tls
      , servant, servant-client, stdenv, text, transformers, url, wai
      }:
      mkDerivation {
        pname = "pokeapi";
        version = "0.1.0.0";
        src = ./.;
        libraryHaskellDepends = [
          aeson base http-client http-client-tls servant servant-client text
          transformers url wai
        ];
        testHaskellDepends = [
          aeson base http-client http-client-tls servant servant-client text
          transformers url wai
        ];
        homepage = "https://github.com/githubuser/pokeapi#readme";
        license = stdenv.lib.licenses.bsd3;
      };

  haskellPackages = if compiler == "default"
                       then pkgs.haskellPackages
                       else pkgs.haskell.packages.${compiler};

  variant = if doBenchmark then pkgs.haskell.lib.doBenchmark else pkgs.lib.id;

  drv = variant (haskellPackages.callPackage f {});

in

  if pkgs.lib.inNixShell then drv.env else drv
