//
//  PokemonViewModel.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import Foundation

protocol PokemonViewModelDelgate {
    func updateTableView()
}

class PokemonViewModel {
    var offset = 0
    let limit = 100
    var isLoadingData = false
    var delegate: PokemonViewModelDelgate?
    var pokemonList: [PokemonResult] = []
    var filteredPokemonList: [PokemonResult] = []
    
    func getPokemonList() {
        isLoadingData = true
        
        PokemonAPI().fetchPokemonList(offset: offset, limit: limit) { result in
            switch result {
            case .success(let pokemonList):
                self.pokemonList.append(contentsOf: pokemonList.results)
                self.filteredPokemonList.append(contentsOf: pokemonList.results)
                self.delegate?.updateTableView()
                self.offset += self.limit
                self.isLoadingData = false
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                self.isLoadingData = false
            }
        }
    }
    
}
