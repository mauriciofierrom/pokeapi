{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Type.Api (type') where

import Data.Proxy (Proxy(..))
import Servant.API ((:>), Capture, Get, JSON)
import Servant.Client (client, ClientM)

import qualified Data.Text as T

import PokeApi.Type.Types

type API = "type" :> Capture "name" T.Text :> Get '[JSON] PokemonType

type' :: T.Text -> ClientM PokemonType

api :: Proxy API
api = Proxy

type' = client api