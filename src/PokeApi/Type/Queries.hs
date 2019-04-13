{-# LANGUAGE OverloadedStrings #-}

module PokeApi.Type.Queries
  ( effectiveAgainst
  , isEffectiveAgainst
  , isWeakAgainst
  , weakAgainst) where

import Control.Monad.Trans.Except (runExceptT, ExceptT(..))
import Control.Monad.Trans.Class (lift)
import Data.Maybe (mapMaybe)
import Network.HTTP.Client (Manager)
import Servant.Client

import qualified Data.Text as T

import PokeApi.Types
import PokeApi.Type.Types
import PokeApi.Type.Api


-- |Returns a list of 'Type's the criteria is strong against
effectiveAgainst :: Manager -> Type' -> PokeApi [Type']
effectiveAgainst = genDamageRelationAccessor doubleDamageTo

-- |Returns a list of 'Type's the criteria is weak against
weakAgainst :: Manager -> Type' -> PokeApi [Type']
weakAgainst = genDamageRelationAccessor doubleDamageFrom

-- |Wether the criteria is weak against the given 'Type'
isWeakAgainst :: Manager -> Type' -> Type' -> PokeApi Bool
isWeakAgainst manager' typeCriteria typeCriteria' = do
  doubleDamagers <- weakAgainst manager' typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

-- |Wether the criteria is effective against the given 'Type'
isEffectiveAgainst :: Manager -> Type' -> Type' -> PokeApi Bool
isEffectiveAgainst manager' typeCriteria typeCriteria' = do
  doubleDamagers <- effectiveAgainst manager' typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

pokemonType :: Manager -> Type' -> PokeApi PokemonType
pokemonType manager' type'' =
  let baseUrl = BaseUrl Https "pokeapi.co" 443 "/api/v2"
      clientEnv = mkClientEnv manager' baseUrl
   in runClientM (type' $ getTypeName type'') clientEnv

damageRelations :: Manager -> Type' -> PokeApi DamageRelation
damageRelations manager' type'' = do
  leType <- pokemonType manager' type''
  return $ fmap typeDamageRelations leType

genDamageRelationAccessor :: (DamageRelation -> [TypeResource])
                          -> Manager
                          -> Type'
                          -> PokeApi [Type']
genDamageRelationAccessor f manager' type'' = do
  leDamageRelations <- damageRelations manager' type''
  case leDamageRelations of
    Left err -> return (Left err :: Either ServantError [Type'])
    Right damageRelation -> return $ Right $ mapMaybe (getType . typeResourceName) (f damageRelation)
