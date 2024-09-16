//
//  PokemonListModel.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import Foundation

struct PokemonListModel: Codable {
    let count: Int
    let next: String?
    let previous: String?
    var results: [PokemonResult]
}
