{-# LANGUAGE DeriveGeneric #-}

module PokeApi.Types where

import Control.Monad.Trans.Reader (ReaderT)
import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client (ClientError, ClientEnv)

import PokeApi.Resource.Types (Resource)

-- type PokeApi a = ReaderT ClientEnv (ExceptT ClientError IO) a
type PokeApi a = ReaderT ClientEnv IO (Either ClientError a)
-- newtype PokeApi a = PokeApi { runPokeApi :: ReaderT ClientEnv IO (Either ClientError a) }

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
