module PokeApi.Types where

import Servant.Client (ServantError)

type PokeApi a = IO (Either ServantError a)
