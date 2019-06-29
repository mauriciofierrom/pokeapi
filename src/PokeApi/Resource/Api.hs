{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Resource.Api (pokemonResource) where

import Data.Proxy (Proxy(..))
import Servant.API ((:>), Capture, Get, JSON)
import Servant.Client (client, ClientM)

import qualified Data.Text as T

import PokeApi.Resource.Types

type API = "type" :> Get '[JSON] PokemonResource

pokemonResource :: ClientM PokemonResource

api :: Proxy API
api = Proxy

pokemonResource = client api
