module PokeApi.Pokemon.Queries
  ( pokemonEncounterByGame
  ) where

import Control.Monad.Trans.Class (lift)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Reader (ask)
import Control.Monad.Trans.Except (except)
import Servant.Client (runClientM)

import PokeApi.Types
import PokeApi.Resource.Types
import PokeApi.Resource.Api

pokemonEncounters :: String -> PokeApi [EncounterResource]
pokemonEncounters pkmnName = do
  env <- ask
  e <- liftIO $ runClientM (pokemonEncounterByName pkmnName) env
  (lift . except) e

pokemonEncounterByGame :: String -> String -> PokeApi [String]
pokemonEncounterByGame pkmnName versionName =
  encResourceToString <$> pokemonEncounters pkmnName
    where
      encResourceToString :: [EncounterResource] -> [String]
      encResourceToString encounters =
        let byGame = filter (elem versionName . fmap (resourceName . vedVersion) . versionDetails) encounters
            encs = fmap (resourceName . locationArea) byGame
         in fmap (fmap (\x -> if x=='-' then ' ' else x)) encs
