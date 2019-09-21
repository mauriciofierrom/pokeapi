{-|
Module      : PokeApi.Common
Description : PokeApi common types and functions.
Copyright   : (c) Mauricio Fierro, 2019
License     : BSD3-Clause
Maintainer  : Mauricio Fierro <mauriciofierrom@gmail.com>

This module contains misc types and functions.
-}

module PokeApi.Common where

import Control.Monad.Trans.Reader (ReaderT)
import Control.Monad.Trans.Except (ExceptT)
import Servant.Client (ClientError, ClientEnv)

type PokeApi = ReaderT ClientEnv (ExceptT ClientError IO)
