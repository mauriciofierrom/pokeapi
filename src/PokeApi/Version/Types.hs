{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module PokeApi.Version.Types where

import Data.Aeson (FromJSON, withObject, parseJSON, (.:))

import PokeApi.Resource.Types

data Version =
  Version { versionName :: String
          , versionNames :: [String]
          , versionGroup :: Resource
          } deriving (Eq, Show)

instance FromJSON Version where
  parseJSON = withObject "version" $ \v -> do
    versionName <- v .: "name"
    versionNames <- v .: "names"
    versionGroup <- v .: "version_group"
    return Version{..}
