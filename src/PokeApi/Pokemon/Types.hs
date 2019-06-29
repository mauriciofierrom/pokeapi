{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Pokemon.Types where

import Data.Aeson

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
