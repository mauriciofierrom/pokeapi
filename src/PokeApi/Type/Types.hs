{-# LANGUAGE OverloadedStrings #-}

module PokeApi.Type.Types 
  ( getTypeName
  , getType
  , DamageRelation(..)
  , PokemonType(..)
  , Type'(..)
  , TypeResource(..))where

import Data.Aeson ((.:), parseJSON, FromJSON, withObject)

import qualified Data.Text as T

data TypeResource = TypeResource { typeResourceName :: !T.Text
                                 , typeResourceUrl  :: !T.Text
                                 } deriving (Eq, Show)

instance FromJSON TypeResource where
  parseJSON = withObject "type_resource" $ \t ->
    TypeResource <$> t .: "name"
                 <*> t .: "url"

data DamageRelation =
  DamageRelation { noDamageTo :: [TypeResource]
                 , halfDamageTo :: [TypeResource]
                 , doubleDamageTo :: [TypeResource]
                 , noDamageFrom :: [TypeResource]
                 , halfDamageFrom :: [TypeResource]
                 , doubleDamageFrom :: [TypeResource]
                 } deriving (Eq, Show)

instance FromJSON DamageRelation where
  parseJSON = withObject "damage_relations" $ \d ->
    DamageRelation <$> d .: "no_damage_to"
                   <*> d .: "half_damage_to"
                   <*> d .: "double_damage_to"
                   <*> d .: "no_damage_from"
                   <*> d .: "half_damage_from"
                   <*> d .: "double_damage_from"

data PokemonType =
  PokemonType { typeName :: !T.Text
              , typeDamageRelations :: DamageRelation 
              } deriving (Eq, Show)

instance FromJSON PokemonType where
  parseJSON = withObject "pokemon_type" $ \p -> PokemonType
    <$> p .: "name"
    <*> p .: "damage_relations"

data Type' = Normal
           | Fire
           | Water
           | Electric
           | Grass
           | Ice
           | Fighting
           | Poison
           | Ground
           | Flying
           | Psychic
           | Bug
           | Rock
           | Ghost
           | Dragon
           | Dark
           | Steel
           | Fairy
           deriving (Eq, Show)

getTypeName :: Type' -> T.Text
getTypeName Normal = "normal"
getTypeName Fire = "fire"
getTypeName Grass = "grass"
getTypeName Water = "water"
getTypeName Electric = "electric"
getTypeName Ice = "ice"
getTypeName Fighting = "fighting"
getTypeName Poison = "poison"
getTypeName Ground = "ground"
getTypeName Flying = "flying"
getTypeName Psychic = "psychic"
getTypeName Bug = "bug"
getTypeName Rock = "rock"
getTypeName Ghost = "ghost"
getTypeName Dragon = "dragon"
getTypeName Dark = "dark"
getTypeName Steel = "steel"
getTypeName Fairy = "fairy"


getType :: T.Text -> Maybe Type'
getType type' =
  case T.toLower type' of
    "normal" -> Just Normal
    "fire" -> Just Fire
    "grass" -> Just Grass
    "water" -> Just Water
    "electric" -> Just Electric
    "ice" -> Just Ice
    "fighting" -> Just Fighting
    "poison" -> Just Poison
    "ground" -> Just Ground
    "flying" -> Just Flying
    "psychic" -> Just Psychic
    "bug" -> Just Bug
    "rock" -> Just Rock
    "ghost" -> Just Ghost
    "dragon" -> Just Dragon
    "dark" -> Just Dark
    "steel" -> Just Steel
    "fairy" -> Just Fairy
    _ -> Nothing
