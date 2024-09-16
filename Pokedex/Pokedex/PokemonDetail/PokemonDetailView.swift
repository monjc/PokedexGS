//
//  PokemonDetailView.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import SwiftUI

struct PokemonDetailView: View {
    var pokemon: PokemonResult
    @StateObject var viewModel = PokemonDetailViewModel()
    
    var body: some View {
        ScrollView{
            
            VStack (spacing: 20){
                if let pokemonDetail = viewModel.pokemonModel {
                    // Imagen del Pokémon con fondo adaptable
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color.blue.opacity(0.2))  // Cambiar a color adaptable
                            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
                            .frame(height: 250)
                        
                        // Imagen asíncrona
                        AsyncImage(url: URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonDetail.id).png")) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 150, height: 150)
                                    .transition(.scale) // Transición suave cuando la imagen aparece
                            } else if phase.error != nil {
                                Text("Error al cargar la imagen")
                                    .foregroundColor(.red)
                            } else {
                                ProgressView() // Indicador de carga
                                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                                    .scaleEffect(1.5) // Indicador más grande
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    // Nombre del Pokémon
                    Text(pokemonDetail.name.capitalized)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top)
                    
                    // Tipos del Pokémon
                    if let list = viewModel.pokemonModel?.types {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(list, id: \.self) { item in
                                    Text(item.type.name.capitalized)
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
                                        .padding(8)
                                        .background(Color.yellow)
                                        .cornerRadius(12)
                                        .foregroundColor(.white)
                                }
                            }
                            .frame(maxWidth: .infinity) // Ocupa todo el ancho posible
                            .padding(.horizontal)
                            .multilineTextAlignment(.center) // Alinea el texto al centro
                        }
                        .frame(maxWidth: .infinity, alignment: .center) // Centra el ScrollView
                    }

                    
                    // Sección de descripción
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Descripción")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        if let description = viewModel.pokemonDescription {
                            Text(description)
                                .font(.body)
                                .multilineTextAlignment(.leading)
                                .lineLimit(nil)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal)
                        } else {
                            Text("Cargando descripción...")
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 5)
                    
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Estadísticas")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(pokemonDetail.stats, id: \.stat.name) { stat in
                            VStack(alignment: .leading) {
                                Text("\(stat.stat.name.capitalized): \(stat.baseStat)")
                                    .font(.subheadline)
                                ProgressView(value: Float(stat.baseStat), total: 100) // El máximo para las estadísticas
                                    .accentColor(.green)
                            }
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                    
                    VStack(alignment: .leading) {
                        Text("Movimientos")
                            .font(.headline)
                            .padding(.bottom, 5)
                        
                        ForEach(pokemonDetail.moves.prefix(5), id: \.move.name) { move in // Solo mostramos 5 movimientos
                            Text(move.move.name.capitalized)
                                .padding(.vertical, 5)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .padding(.vertical, 2)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    .padding(.horizontal)
                } else {
                    ProgressView("Cargando detalles del Pokémon...")
                }
            }
            .onAppear{
                viewModel.getPokemonDetail(url: pokemon.url)
            }
            .navigationTitle(pokemon.name.capitalized)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    PokemonDetailView(pokemon: PokemonResult(id: 1, name: "bulbasaur", url: "https://pokeapi.co/api/v2/pokemon/1/"))
}
