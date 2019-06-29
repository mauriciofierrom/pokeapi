{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.LocationArea.Types where

import Data.Aeson (FromJSON, (.:), parseJSON, withObject)

-- TODO: Missing EncounterMethodRates
data LocationArea =
  LocationArea { laId :: Int
               , laName :: String
               , laGameIndex :: Int
               } deriving (Eq, Show)

instance FromJSON LocationArea where
  parseJSON = withObject "locationArea" $ \la -> do
    laId <- la .: "id"
    laName <- la .: "name"
    laGameIndex <- la .: "game_index"
    return LocationArea{..}
