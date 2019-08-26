{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE UndecidableInstances #-}

module PokeApi.Types where

import Control.Monad.Reader
import Control.Monad.Except
import Data.Aeson (FromJSON)
import GHC.Generics
import Servant.Client

import PokeApi.Resource.Types (Resource)

type PokeApi a = IO (Either ServantError a)

class ( MonadReader ClientEnv m
      , MonadError ServantError m
      , MonadIO m)
      => HasPokeApi m where
  runPokeApi :: ClientM a -> m a

instance ( MonadReader ClientEnv m
         , MonadError ServantError m
         , MonadIO m ) =>
           HasPokeApi m where
           runPokeApi action = do
             clientEnv <- ask
             res <- liftIO $ runClientM action clientEnv
             liftEither res

data Name =
  Name { name :: String
       , language :: [Resource]
       } deriving (Eq, Show, Generic)

instance FromJSON Name
