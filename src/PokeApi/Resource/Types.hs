{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Resource.Types
  ( EncounterResource(..)
  , PokemonResource(..)
  , Resource(..)
  , VersionEncounterDetail(..)
  ) where

import Data.Aeson (parseJSON, withObject, FromJSON, (.:))

data Resource =
  Resource { resourceName :: String
           , resourceUrl :: String
           } deriving (Eq, Show)

instance FromJSON Resource where
  parseJSON = withObject "resource" $ \r -> do
    resourceName <- r .: "name"
    resourceUrl <- r .: "url"
    return Resource{..}

data PokemonResource =
  PokemonResource { prCount :: Int
                  , prNext :: Maybe String
                  , prPrevious :: Maybe String
                  , prResults :: [Resource]
                  } deriving (Eq, Show)

instance FromJSON PokemonResource where
  parseJSON = withObject "pokemonResource" $ \pr -> do
    prCount <- pr .: "count"
    prNext <- pr .: "next"
    prPrevious <- pr .: "previous"
    prResults <- pr .: "results"
    return PokemonResource{..}

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
                    } deriving (Eq, Show)

instance FromJSON EncounterResource where
  parseJSON = withObject "encounter_resource" $ \er -> do
    locationArea <- er .: "location_area"
    versionDetails <- er .: "version_details"
    return EncounterResource{..}
