{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Resource.Api (pokemonResource) where

import Data.Proxy (Proxy(..))
import Servant.API ((:>), Get, JSON, QueryParam)
import Servant.Client (client, ClientM)

import PokeApi.Resource.Types

type API = "pokemon" :> QueryParam "offset" Int :> QueryParam "limit" Int :> Get '[JSON] PokemonResource

pokemonResource :: Maybe Int -> Maybe Int -> ClientM PokemonResource

api :: Proxy API
api = Proxy

pokemonResource = client api
