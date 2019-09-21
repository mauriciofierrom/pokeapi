{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.LocationArea.Types where

import Data.Aeson (FromJSON, (.:), parseJSON, withObject)

-- TODO: Missing EncounterMethodRates
-- | Location areas are sections of areas, such as floors in a building or cave.
-- Each area has its own set of possible Pokémon encounters.
data LocationArea =
  LocationArea { laId :: Int
                 -- ^ Identifier.
               , laName :: String
                 -- ^ Name.
               , laGameIndex :: Int
                 -- ^ The internal id of an API resource with game data.
               } deriving (Eq, Show)

instance FromJSON LocationArea where
  parseJSON = withObject "locationArea" $ \la -> do
    laId <- la .: "id"
    laName <- la .: "name"
    laGameIndex <- la .: "game_index"
    return LocationArea{..}
