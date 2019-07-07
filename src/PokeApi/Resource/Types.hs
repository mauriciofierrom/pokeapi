{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Resource.Types where

import Data.Aeson (FromJSON, parseJSON, withObject, (.:))
import GHC.Generics

import PokeApi.LocationArea.Types

data Resource =
  Resource { name :: String
           , url :: String
           } deriving (Eq, Show, Generic)

instance FromJSON Resource

data PokemonResource =
  PokemonResource { count :: Int
                  , next :: Maybe String
                  , previous :: Maybe String
                  , results :: [Resource]
                  } deriving (Eq, Show, Generic)

instance FromJSON PokemonResource


data VersionEncounterDetail =
  VersionEncounterDetail { vedVersion :: Resource
                         , vedMaxChance :: Int
                         -- , vedEncounterDetails :: [Encounter]
                         } deriving (Eq, Show)

instance FromJSON VersionEncounterDetail where
  parseJSON = withObject "version_details" $ \ved -> do
    vedVersion <- ved .: "version"
    vedMaxChance <- ved .: "max_chance"
    return VersionEncounterDetail{..}

data EncounterResource =
  EncounterResource { locationArea :: Resource
                    , versionDetails :: [VersionEncounterDetail]
                    } deriving (Eq, Show, Generic)

instance FromJSON EncounterResource where
  parseJSON = withObject "encounter_resource" $ \er -> do
    locationArea <- er .: "location_area"
    versionDetails <- er .: "version_details"
    return EncounterResource{..}
