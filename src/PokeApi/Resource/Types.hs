{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Resource.Types where

import Data.Aeson ((.:), parseJSON, FromJSON, withObject)
import GHC.Generics

data Resource =
  Resource { name :: String
           , url :: String
           } deriving (Eq, Show, Generic)

instance FromJSON Resource

data PokemonResource =
  PokemonResource { count :: Int
                  , next :: String
                  , previous :: String
                  , results :: [Resource]
                  } deriving (Eq, Show, Generic)

instance FromJSON PokemonResource
