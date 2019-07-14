{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE NamedFieldPuns #-}
{-# LANGUAGE LambdaCase #-}

module PokeApi.Pokemon.Queries where

import Servant.Client (runClientM, ClientEnv)

import PokeApi.Types
import PokeApi.Pokemon.Api
import PokeApi.Pokemon.Types
import PokeApi.Resource.Types
import PokeApi.Resource.Api
import PokeApi.Version.Types
import PokeApi.LocationArea.Types

pokemonEncounters :: ClientEnv -> String -> PokeApi [EncounterResource]
pokemonEncounters env pkmnName = runClientM (pokemonEncounterByName pkmnName) env

pokemonEncounterByGame :: ClientEnv -> String -> String -> PokeApi [String]
pokemonEncounterByGame env pkmnName versionName =
  pokemonEncounters env pkmn >>= \case
    Left err -> return (Left err)
    Right encounters -> do
      let byGame = filter (\x -> elem versionName (fmap (PokeApi.Resource.Types.name . vedVersion)  (versionDetails x))) encounters
          encs = fmap (PokeApi.Resource.Types.name . locationArea) byGame
       in return . Right $ map (map (\x -> if x=='-' then ' ' else x)) encs
