{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Types where

import Control.Monad.Trans.Reader (ReaderT)
import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client (ClientError, ClientEnv)

import PokeApi.Resource.Types (Resource)

type PokeApi = ReaderT ClientEnv IO
type ClientResponse a = Either ClientError a

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
