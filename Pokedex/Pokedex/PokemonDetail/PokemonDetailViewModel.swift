//
//  PokemonDetailViewModel.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import Foundation
import Combine

/*class PokemonDetailViewModel: ObservableObject {
    
    @Published var pokemonModel: PokemonModel? // Aquí almacenamos los detalles del Pokémon
    private var cancellable: AnyCancellable?
    private let api = PokemonAPI()
    
    func getPokemonDetail(url: String) {
        cancellable = api.fetchDetail(url: url)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { pokemonModel in
                self.pokemonModel = pokemonModel
            })
    }
}*/

class PokemonDetailViewModel: ObservableObject {
    
    @Published var pokemonModel: PokemonModel? // Detalles del Pokémon
    @Published var pokemonDescription: String? // Descripción del Pokémon
    private var cancellable: AnyCancellable?
    private let api = PokemonAPI()
    
    func getPokemonDetail(url: String) {
        cancellable = api.fetchDetail(url: url)
            .flatMap { pokemonModel -> AnyPublisher<PokemonSpecies, Error> in
                self.pokemonModel = pokemonModel
                return self.api.fetchPokemonSpecies(url: pokemonModel.species.url)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("Error: \(error)")
                }
            }, receiveValue: { species in
                // Filtramos la descripción en el idioma deseado (español o inglés)
                if let description = species.flavorTextEntries.first(where: { $0.language.name == "en" })?.flavorText {
                    self.pokemonDescription = description
                }
            })
    }
}
