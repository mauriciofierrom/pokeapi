{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Types where

import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client (ServantError)

import PokeApi.Resource.Types (Resource)

type PokeApi a = IO (Either ServantError a)

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
