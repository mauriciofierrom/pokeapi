{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE RecordWildCards #-}

module Main where

import Control.Monad.Trans.Reader (runReaderT)
import Control.Monad.Trans.Except (runExceptT)
import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Servant.Client
import System.IO

import qualified Data.Text as T

import PokeApi.Type.Types
import PokeApi.Resource.Api
import PokeApi.Resource.Types
import PokeApi.Type.Queries

import Network.URL

main :: IO ()
main = do
  manager' <- newManager tlsManagerSettings
  let clientEnv = mkClientEnv manager' (BaseUrl Https "pokeapi.co" 443 "/api/v2")
   in do
     res <- runExceptT $ runReaderT (isWeakAgainst Poison Fire) clientEnv
     case res of
       Left e -> print e
       Right val -> print val
   -- withFile "version.csv" WriteMode $ \h -> do
   --   writePokemon versionResource clientEnv h

processTypes :: DamageRelation -> [T.Text]
processTypes damageRelation = fmap typeResourceName (doubleDamageFrom damageRelation)

writePokemon :: ClientM PokemonResource -> ClientEnv -> Handle -> IO ()
writePokemon client env handle = do
  res <- runClientM client env
  case res of
    Left err -> putStrLn $ "Error: " <> show err
    Right resource -> do
      mapM_ (\Resource{..} -> hPutStrLn handle ("\"" <> name <> "\",\"" <> name <> "\"")) (results resource)
      case (next resource) of
        Just url -> do
          let (offset, limit) = extractParams url
           in writePokemon (pokemonResource (Just offset) (Just limit)) env handle
        Nothing -> return ()

extractParams :: String -> (Int, Int)
extractParams url =
  let mbUrl = importURL url
    in case mbUrl of
         Just url ->
           -- Unsafe. Use readMaybe.
           let (x:(x':_)) = fmap ((read :: String -> Int) . snd) $ url_params url
            in (x,x')
         Nothing -> error "Not enough arguments"
