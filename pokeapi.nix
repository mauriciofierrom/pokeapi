{ mkDerivation, aeson, base, http-client, http-client-tls, servant
, servant-client, stdenv, text, transformers, url, wai
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
}
