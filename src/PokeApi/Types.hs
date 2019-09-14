{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Types where

import Control.Monad.Trans.Reader (ReaderT)
import Control.Monad.Trans.Except (ExceptT)
import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client (ClientError, ClientEnv)

import PokeApi.Resource.Types (Resource)

type PokeApi = ReaderT ClientEnv (ExceptT ClientError IO)

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
