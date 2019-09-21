{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Pokemon.Types
  ( EncounterParams(..)
  , Pokemon(..)
  , PokemonName
  , PokemonGame
  ) where

import Data.Aeson (parseJSON, withObject, FromJSON, (.:))

-- | Pokemon type.
data Pokemon =
  Pokemon { pkmnId :: Int
            -- ^ Identifier of this resource.
          , pkmnName :: PokemonName
            -- ^ The Pokemon name.
          , pkmnLocationAreaEncounters :: String
            -- ^ The LocationAreaEncounter resource url.
          } deriving (Eq, Show)

instance FromJSON Pokemon where
  parseJSON = withObject "pokemon" $ \p -> do
    pkmnId <- p .: "id"
    pkmnName <- p .: "name"
    pkmnLocationAreaEncounters <- p .: "location_area_encounters"
    return Pokemon{..}

type PokemonName = String
type PokemonGame = String

-- | Parameters for querying an encounter.
data EncounterParams =
  EncounterParams { name :: PokemonName
                    -- ^ The name of the Pokemon.
                  , game :: PokemonGame
                    -- ^ The name of the PokemonGame.
                  } deriving (Eq, Show)
