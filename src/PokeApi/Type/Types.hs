{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveGeneric     #-}

module PokeApi.Type.Types where

import Data.Aeson ((.:), parseJSON, FromJSON, withObject)
import GHC.Generics (Generic)

import qualified Data.Text as T

data TypeResource = TypeResource { typeResourceName :: !T.Text
                                 , typeResourceUrl  :: !T.Text }
                                 deriving (Show, Generic)

instance FromJSON TypeResource where
  parseJSON = withObject "type_resource" $ \t -> TypeResource
    <$> t .: "name"
    <*> t .: "url"

data DamageRelation =
  DamageRelation { noDamageTo :: [TypeResource]
                 , halfDamageTo :: [TypeResource]
                 , doubleDamageTo :: [TypeResource]
                 , noDamageFrom :: [TypeResource]
                 , halfDamageFrom :: [TypeResource]
                 , doubleDamageFrom :: [TypeResource] }
                                     deriving (Show, Generic)

instance FromJSON DamageRelation where
  parseJSON = withObject "damage_relations" $ \d -> DamageRelation
    <$> d .: "no_damage_to"
    <*> d .: "half_damage_to"
    <*> d .: "double_damage_to"
    <*> d .: "no_damage_from"
    <*> d .: "half_damage_from"
    <*> d .: "double_damage_from"

data PokemonType =
  PokemonType { typeName :: !T.Text
              , typeDamageRelations :: DamageRelation }
                               deriving (Show, Generic)

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
getType "normal" = Just Normal
getType "fire" = Just Fire
getType "water" = Just Water
getType "electric" = Just Electric
getType "ice" = Just Ice
getType "fighting" = Just Fighting
getType "poison" = Just Poison
getType "ground" = Just Ground
getType "flying" = Just Flying
getType "psychic" = Just Psychic
getType "bug" = Just Bug
getType "rock" = Just Rock
getType "ghost" = Just Ghost
getType "dragon" = Just Dragon
getType "dark" = Just Dark
getType "steel" = Just Steel
getType "fairy" = Just Fairy
getType _ = Nothing
