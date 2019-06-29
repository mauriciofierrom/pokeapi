{-# LANGUAGE NamedFieldPuns #-}

module PokeApi.Pokemon.Queries where
import PokeApi.Pokemon.Api

pokemonEncounterByString :: ClientEnv -> Pokemon -> PokeApi [EncounterResource]
pokemonEncounterByString env Pokemon{pkmnId} = runClientM (pokemonEncounterById pkmnId)
