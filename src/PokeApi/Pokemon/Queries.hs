module PokeApi.Pokemon.Queries
  ( pokemonEncounterByGame
  ) where

import Control.Monad.Trans.Class (lift)
import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Reader (ask)
import Control.Monad.Trans.Except (except)
import Servant.Client (runClientM)

import PokeApi.Common
import PokeApi.Resource.Types
import PokeApi.Resource.Api
import PokeApi.Pokemon.Types (PokemonGame, PokemonName)

pokemonEncounters :: PokemonName -> PokeApi [EncounterResource]
pokemonEncounters pkmnName = do
  env <- ask
  e <- liftIO $ runClientM (pokemonEncounterByName pkmnName) env
  (lift . except) e

-- | Get a list of the possible Pokemon encounters in a game.
pokemonEncounterByGame :: PokemonName -> PokemonGame -> PokeApi [String]
pokemonEncounterByGame pkmnName versionName =
  encResourceToString <$> pokemonEncounters pkmnName
    where
      encResourceToString :: [EncounterResource] -> [String]
      encResourceToString encounters =
        let byGame = filter (elem versionName . fmap (resourceName . vedVersion) . versionDetails) encounters
            encs = fmap (resourceName . locationArea) byGame
         in fmap (fmap (\x -> if x=='-' then ' ' else x)) encs
