{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Resource.Types where

import Data.Aeson (FromJSON)
import GHC.Generics

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
