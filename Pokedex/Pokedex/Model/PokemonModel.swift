//
//  PokemonModel.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 15/09/24.
//

import Foundation

struct PokemonModel: Codable {
    let abilities: [AbilityEntry]
    let baseExperience: Int
    let forms: [Form]
    let height: Int
    let heldItems: [HeldItem]
    let id: Int
    let isDefault: Bool
    let locationAreaEncounters: String
    let moves: [MoveEntry]
    let name: String
    let order: Int
    let pastAbilities: [PastAbility]
    let pastTypes: [PastType]
    let species: Species
    let stats: [StatEntry]
    let types: [TypeEntry]
    let weight: Int

    enum CodingKeys: String, CodingKey {
        case abilities
        case baseExperience = "base_experience"
        case forms
        case height
        case heldItems = "held_items"
        case id
        case isDefault = "is_default"
        case locationAreaEncounters = "location_area_encounters"
        case moves
        case name
        case order
        case pastAbilities = "past_abilities"
        case pastTypes = "past_types"
        case species
        case stats
        case types
        case weight
    }
}

struct AbilityEntry: Codable {
    let ability: Ability
    let isHidden: Bool
    let slot: Int

    enum CodingKeys: String, CodingKey {
        case ability
        case isHidden = "is_hidden"
        case slot
    }
}

struct Ability: Codable {
    let name: String
    let url: String
}

struct Form: Codable {
    let name: String
    let url: String
}

struct HeldItem: Codable {}

struct MoveEntry: Codable {
    let move: Move
}

struct Move: Codable {
    let name: String
    let url: String
}

struct PastAbility: Codable {}

struct PastType: Codable {}

struct Species: Codable {
    let name: String
    let url: String
}

struct StatEntry: Codable {
    let baseStat: Int
    let effort: Int
    let stat: Stat

    enum CodingKeys: String, CodingKey {
        case baseStat = "base_stat"
        case effort
        case stat
    }
}

struct Stat: Codable {
    let name: String
    let url: String
}

struct TypeEntry: Codable, Hashable {
    static func == (lhs: TypeEntry, rhs: TypeEntry) -> Bool {
        return lhs.slot == rhs.slot && lhs.type == rhs.type
    }
    
    let slot: Int
    let type: Type
}

struct Type: Codable, Hashable {
    static func == (lhs: Type, rhs: Type) -> Bool {
        return lhs.name == lhs.name && rhs.url == rhs.url
    }
    
    let name: String
    let url: String
}

struct PokemonSpecies: Codable {
    let flavorTextEntries: [FlavorTextEntry]

    enum CodingKeys: String, CodingKey {
        case flavorTextEntries = "flavor_text_entries"
    }
}

struct FlavorTextEntry: Codable {
    let flavorText: String
    let language: Language

    enum CodingKeys: String, CodingKey {
        case flavorText = "flavor_text"
        case language
    }
}

struct Language: Codable {
    let name: String
}

