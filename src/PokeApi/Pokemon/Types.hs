{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Pokemon.Types 
  ( EncounterParams(..)
  , Pokemon(..) 
  ) where

import Data.Aeson (parseJSON, withObject, FromJSON, (.:))

data Pokemon =
  Pokemon { pkmnId :: Int
          , pkmnName :: String
          , pkmnLocationAreaEncounters :: String
          } deriving (Eq, Show)

instance FromJSON Pokemon where
  parseJSON = withObject "pokemon" $ \p -> do
    pkmnId <- p .: "id"
    pkmnName <- p .: "name"
    pkmnLocationAreaEncounters <- p .: "location_area_encounters"
    return Pokemon{..}

data EncounterParams =
  EncounterParams { pkmn :: String
                  , game :: String
                  } deriving (Eq, Show)
