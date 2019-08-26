{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE MonoLocalBinds #-}
{-# LANGUAGE OverloadedStrings #-}

module PokeApi.Type.Queries where

import Control.Monad.Reader
import Control.Monad.Except
import Data.Maybe (mapMaybe)
import Network.HTTP.Client (Manager)
import Servant.Client

import PokeApi.Types
import PokeApi.Type.Types
import PokeApi.Type.Api

pkmnType :: HasPokeApi m => Type' -> m PokemonType
pkmnType t = runPokeApi (type' $ getTypeName t)

-- |Returns a list of 'Type's the criteria is strong against

effectiveAgainst :: Manager -> Type' -> PokeApi [Type']
effectiveAgainst = genDamageRelationAccessor doubleDamageTo

effAgainst
  :: HasPokeApi m
  => Type'
  -> m [Type']
effAgainst =
  genDmgRelAcc doubleDamageTo

-- |Returns a list of 'Type's the criteria is weak against
weakAgainst :: Manager -> Type' -> PokeApi [Type']
weakAgainst = genDamageRelationAccessor doubleDamageFrom

weakA
  :: HasPokeApi m
  => Type'
  -> m [Type']
weakA = genDmgRelAcc doubleDamageFrom

-- |Wether the criteria is weak against the given 'Type'
isWeakAgainst :: Manager -> Type' -> Type' -> PokeApi Bool
isWeakAgainst manager' typeCriteria typeCriteria' = do
  doubleDamagers <- weakAgainst manager' typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

isWeakA
  :: HasPokeApi m
  => Type'
  -> Type'
  -> m Bool
isWeakA t t' = do
  doubleDamagers <- weakA t
  return $ elem t' doubleDamagers

-- |Wether the criteria is effective against the given 'Type'
isEffectiveAgainst :: Manager -> Type' -> Type' -> PokeApi Bool
isEffectiveAgainst manager' typeCriteria typeCriteria' = do
  doubleDamagers <- effectiveAgainst manager' typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

isEffA
  :: HasPokeApi m
  => Type'
  -> Type'
  -> m Bool
isEffA t t' = do
  doubleDamagers <- effAgainst t
  return $ elem t' doubleDamagers

pokemonType :: Manager -> Type' -> PokeApi PokemonType
pokemonType manager' type'' =
  let baseUrl = BaseUrl Https "pokeapi.co" 443 "/api/v2"
      clientEnv = mkClientEnv manager' baseUrl
   in runClientM (type' $ getTypeName type'') clientEnv

damageRelations :: Manager -> Type' -> PokeApi DamageRelation
damageRelations manager' type'' = do
  leType <- pokemonType manager' type''
  return $ fmap typeDamageRelations leType

dmgRelations :: HasPokeApi m => Type' -> m DamageRelation
dmgRelations t = do
  leType <- pkmnType t
  return $ typeDamageRelations leType

genDamageRelationAccessor :: (DamageRelation -> [TypeResource])
                          -> Manager
                          -> Type'
                          -> PokeApi [Type']
genDamageRelationAccessor f manager' type'' = do
  leDamageRelations <- damageRelations manager' type''
  case leDamageRelations of
    Left err -> return (Left err :: Either ServantError [Type'])
    Right damageRelation -> return $ Right $ mapMaybe (getType . typeResourceName) (f damageRelation)

genDmgRelAcc
  :: HasPokeApi m
  => (DamageRelation -> [TypeResource])
  -> Type'
  -> m [Type']
genDmgRelAcc f t = do
  rels <- dmgRelations t
  return $ mapMaybe (getType . typeResourceName) (f rels)
