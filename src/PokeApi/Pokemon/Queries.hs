{-# LANGUAGE LambdaCase #-}

module PokeApi.Pokemon.Queries where

import Servant.Client (runClientM)

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Reader (ask)
import PokeApi.Types
import PokeApi.Resource.Types
import PokeApi.Resource.Api

pokemonEncounters :: String -> PokeApi [EncounterResource]
pokemonEncounters pkmnName = do
  env <- ask
  liftIO $ runClientM (pokemonEncounterByName pkmnName) env

pokemonEncounterByGame :: String -> String -> PokeApi [String]
pokemonEncounterByGame pkmnName versionName =
  pokemonEncounters pkmnName >>= \case
    Left err -> return (Left err)
    Right encounters ->
      let byGame = filter (\x -> elem versionName (fmap (PokeApi.Resource.Types.name . vedVersion)  (versionDetails x))) encounters
          encs = fmap (PokeApi.Resource.Types.name . locationArea) byGame
       in return . Right $ map (map (\x -> if x=='-' then ' ' else x)) encs
