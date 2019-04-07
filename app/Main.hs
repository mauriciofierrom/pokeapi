{-# LANGUAGE OverloadedStrings #-}
module Main where

import Network.HTTP.Client (newManager)
import Network.HTTP.Client.TLS (tlsManagerSettings)
import Servant.Client

import qualified Data.Text as T

import Type.Api
import Type.Types

main :: IO ()
main = do
  manager' <- newManager tlsManagerSettings
  res <- runClientM (type' "fairy") (mkClientEnv manager' (BaseUrl Https "pokeapi.co" 443 "/api/v2"))
  case res of
    Left err -> putStrLn $ "Error: " ++ show err
    Right pokemonType -> print (processTypes $ typeDamageRelations pokemonType)

processTypes :: DamageRelation -> [T.Text]
processTypes damageRelation = fmap typeResourceName (doubleDamageFrom damageRelation)
