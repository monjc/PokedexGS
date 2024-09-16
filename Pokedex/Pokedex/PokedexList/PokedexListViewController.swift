//
//  ViewController.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import UIKit
import SwiftUI

class PokedexListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    
    var viewModel = PokemonViewModel()
    var delegate: PokemonViewModelDelgate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setTableView()
        setSearchBar()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getPokemonList()
    }
}

extension PokedexListViewController {
    func setTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib.init(nibName: "PokemonTableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
    }
    
    func setSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = "Buscar Pokémon"
    }
}

extension PokedexListViewController: PokemonViewModelDelgate {
    func updateTableView() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    
}

extension PokedexListViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredPokemonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PokemonTableViewCell else {
            return UITableViewCell()
        }
        let pokemon = viewModel.filteredPokemonList[indexPath.row]
        cell.configure(pokemon: pokemon)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pokemon = viewModel.filteredPokemonList[indexPath.row]
        
        // Inicializa la vista de detalle de SwiftUI con el Pokémon seleccionado
        let detailView = PokemonDetailView(pokemon: pokemon)
        let hostingController = UIHostingController(rootView: detailView)
        
        // Empuja el controlador de SwiftUI en el stack de navegación
        navigationController?.pushViewController(hostingController, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            if !viewModel.isLoadingData {
                viewModel.getPokemonList()
            }
        }
    }
}

extension PokedexListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            viewModel.filteredPokemonList = viewModel.pokemonList
        } else {
            viewModel.filteredPokemonList = viewModel.pokemonList.filter { pokemon in
                return pokemon.name.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
