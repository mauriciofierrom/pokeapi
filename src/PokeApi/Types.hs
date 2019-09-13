{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Types where

import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client (ClientError)

import PokeApi.Resource.Types (Resource)

type PokeApi a = IO (Either ClientError a)

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
