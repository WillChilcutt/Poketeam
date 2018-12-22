//
//  PTTrainer.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

class PTTrainer : NSObject, Codable
{
    let name : String
    private(set) var pokemonIdsArray : [Int] = []
    
    init(withName name : String)
    {
        self.name = name
        super.init()
    }
    
    func getPokemon() -> [PTPokemon]
    {
        var pokemonArray : [PTPokemon] = []
        
        for pokemonId in self.pokemonIdsArray
        {
            if let pokemon = try? PTStorageDataSource.getPokemon(withId: pokemonId)
            {
                pokemonArray.append(pokemon)
            }
        }
        
        return pokemonArray
    }
    
    func addPokemon(_ pokemonArray : [PTPokemon])
    {
        var newPokemonIdsArray : [Int] = []
        
        for pokemon in pokemonArray
        {
            newPokemonIdsArray.append(pokemon.id)
        }
        
        pokemonIdsArray.append(contentsOf: newPokemonIdsArray)
    }
    
    func removePokemon(_ pokemonArray : [PTPokemon])
    {
        for pokemon in pokemonArray
        {
            guard let indexOfPokemon = self.pokemonIdsArray.index(of: pokemon.id) else { continue }
            
            self.pokemonIdsArray.remove(at: indexOfPokemon)
        }
        
    }
}
