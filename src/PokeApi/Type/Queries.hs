{-# LANGUAGE OverloadedStrings #-}

module PokeApi.Type.Queries
  ( effectiveAgainst
  , isEffectiveAgainst
  , isWeakAgainst
  , weakAgainst) where

import Control.Monad.IO.Class (liftIO)
import Control.Monad.Trans.Reader (ask)
import Data.Maybe (mapMaybe)
import Servant.Client

import PokeApi.Types
import PokeApi.Type.Types
import PokeApi.Type.Api


-- |Returns a list of 'Type's the criteria is strong against
effectiveAgainst :: Type' -> PokeApi [Type']
effectiveAgainst = genDamageRelationAccessor doubleDamageTo

-- |Returns a list of 'Type's the criteria is weak against
weakAgainst :: Type' -> PokeApi [Type']
weakAgainst = genDamageRelationAccessor doubleDamageFrom

-- |Wether the criteria is weak against the given 'Type'
isWeakAgainst :: Type' -> Type' -> PokeApi Bool
isWeakAgainst typeCriteria typeCriteria' = do
  doubleDamagers <- weakAgainst typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

-- |Wether the criteria is effective against the given 'Type'
isEffectiveAgainst :: Type' -> Type' -> PokeApi Bool
isEffectiveAgainst typeCriteria typeCriteria' = do
  doubleDamagers <- effectiveAgainst typeCriteria
  return $ elem typeCriteria' <$> doubleDamagers

pokemonType :: Type' -> PokeApi PokemonType
pokemonType type'' = do
  clientEnv <- ask
  liftIO $ runClientM (type' $ getTypeName type'') clientEnv

damageRelations :: Type' -> PokeApi DamageRelation
damageRelations type'' = do
  leType <- pokemonType type''
  return $ fmap typeDamageRelations leType

genDamageRelationAccessor :: (DamageRelation -> [TypeResource])
                          -> Type'
                          -> PokeApi [Type']
genDamageRelationAccessor f type'' = do
  leDamageRelations <- damageRelations type''
  case leDamageRelations of
    Left err -> return (Left err :: Either ClientError [Type'])
    Right damageRelation -> return $ Right $ mapMaybe (getType . typeResourceName) (f damageRelation)
