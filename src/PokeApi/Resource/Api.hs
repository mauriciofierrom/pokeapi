{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Resource.Api
  ( pokemonResource
  , pokemonEncounterById
  , pokemonEncounterByName
  ) where

import Data.Proxy (Proxy(..))
import Servant.API -- ((:>), :<|>, Capture, Get, JSON, QueryParam)
import Servant.Client (client, ClientM)

import PokeApi.Resource.Types

type API = "pokemon" :> QueryParam "offset" Int :> QueryParam "limit" Int :> Get '[JSON] PokemonResource
  :<|> "pokemon" :> Capture "name" String :> "encounters" :> Get '[JSON] [EncounterResource]
  :<|> "pokemon" :> Capture "id" Int :> "encounters" :> Get '[JSON] [EncounterResource]

pokemonResource :: Maybe Int -> Maybe Int -> ClientM PokemonResource
pokemonEncounterByName :: String -> ClientM [EncounterResource]
pokemonEncounterById :: Int -> ClientM [EncounterResource]

api :: Proxy API
api = Proxy

pokemonResource :<|> pokemonEncounterByName :<|> pokemonEncounterById = client api
