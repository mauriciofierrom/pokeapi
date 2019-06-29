{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module PokeApi.Pokemon.Api where

import Servant.API
import Servant.Client
import Data.Proxy (Proxy(..))

import PokeApi.Pokemon.Types

type API = "pokemon" :> Capture "name" String :> Get '[JSON] Pokemon
  :<|> "pokemon" :> Capture "id" Int :> Get '[JSON] Pokemon

pokemonByName :: String -> ClientM Pokemon
pokemonById :: Int -> ClientM Pokemon

api :: Proxy API
api = Proxy

pokemonByName :<|> pokemonById = client api
