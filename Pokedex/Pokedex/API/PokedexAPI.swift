//
//  PokedexAPI.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import Foundation
import Combine

class PokemonAPI {
    
    let url = "https://pokeapi.co/api/v2/pokemon"
    
    func fetchPokemonList(offset: Int, limit: Int, completion: @escaping (Result<PokemonListModel, Error>) -> ()) {
        var urlComponents = URLComponents(string: url)
        
        urlComponents?.queryItems = [
            URLQueryItem(name: "offset", value: "\(offset)"),
            URLQueryItem(name: "limit", value: "\(limit)")
        ]
        
        guard let url = urlComponents?.url else {
            print("URL inválida")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error)) // Si ocurre un error, lo retornamos
                return
            }
            
            guard let data = data else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Datos vacíos"])
                completion(.failure(error))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                var pokemonList = try decoder.decode(PokemonListModel.self, from: data)
                for (index, pokemon) in pokemonList.results.enumerated() {
                    pokemonList.results[index].id = offset + index + 1 // id único basado en el offset y el índice
                }
                completion(.success(pokemonList)) // Retornamos el resultado exitoso
            } catch {
                completion(.failure(error)) // Retornamos el error de decodificación
            }
        }
        
        task.resume() // Inicia la tarea de red
    }
    
    func fetchDetail(url: String) -> AnyPublisher<PokemonModel, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func fetchPokemonSpecies(url: String) -> AnyPublisher<PokemonSpecies, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: PokemonSpecies.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }

}
