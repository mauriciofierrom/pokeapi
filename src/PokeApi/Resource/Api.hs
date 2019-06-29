{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Resource.Api
  ( pokemonResource
  , pokemonEncounter ) where

import Data.Proxy (Proxy(..))
import Servant.API -- ((:>), :<|>, Capture, Get, JSON, QueryParam)
import Servant.Client (client, ClientM)

import PokeApi.Resource.Types

type API = "pokemon" :> QueryParam "offset" Int :> QueryParam "limit" Int :> Get '[JSON] PokemonResource
  :<|> "pokemon" :> Capture "id" String :> Get '[JSON] [Resource]

pokemonResource :: Maybe Int -> Maybe Int -> ClientM PokemonResource
pokemonEncounter :: String -> ClientM [Resource]

api :: Proxy API
api = Proxy

pokemonResource :<|> pokemonEncounter = client api
