module PokeApi.Types where

import Control.Monad.Trans.Reader (ReaderT)
import Control.Monad.Trans.Except (ExceptT)
import Servant.Client (ClientError, ClientEnv)

type PokeApi = ReaderT ClientEnv (ExceptT ClientError IO)