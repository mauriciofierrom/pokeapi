{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokemonType.Api where

import Data.Proxy (Proxy(..))
import Servant.API ((:>), Capture, Get, JSON)
import Servant.Client (client, ClientM)

import qualified Data.Text as T

import PokemonType.Types

type API = "type" :> Capture "name" T.Text :> Get '[JSON] PokemonType

type' :: T.Text -> ClientM PokemonType

api :: Proxy API
api = Proxy

type' = client api
