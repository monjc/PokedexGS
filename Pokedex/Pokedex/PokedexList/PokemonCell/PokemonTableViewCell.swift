//
//  PokemonTableViewCell.swift
//  Pokedex
//
//  Created by Mojo Dojo Code House on 14/09/24.
//

import UIKit

class PokemonTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pokemonName: UILabel!
    @IBOutlet weak var backgroundNumber: UIView!
    @IBOutlet weak var pokemonNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        backgroundNumber.layer.cornerRadius = backgroundNumber.frame.height/2
        backgroundNumber.layer.masksToBounds = true
        backgroundNumber.layer.borderWidth = 0.5
        backgroundNumber.layer.borderColor = UIColor.black.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configure(pokemon: PokemonResult) {
        pokemonName.text = pokemon.name
        pokemonNumber.text = pokemon.id?.description
    }
}
