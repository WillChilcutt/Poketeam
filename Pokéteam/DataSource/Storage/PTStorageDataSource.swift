//
//  PTStorageDataSource.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit
import Disk

private let     kPTStorageDataSourceDiskAllPokemonLocation  = "AllPokemon"
private let     kPTStorageDataSourceDiskAllTrainersLocation = "AllTrainers"
private func    kPTStorageDataSourceDiskPokemonLocation(withPokemonId pokemonId : Int) -> String { return "Pokemon-\(pokemonId)"}


class PTStorageDataSource
{
    //MARK: - Pokemon
    
    class func getAllPokemon() throws -> [PTPokemon]
    {
        return try Disk.retrieve(kPTStorageDataSourceDiskAllPokemonLocation, from: .documents, as: [PTPokemon].self)
    }
    
    class func getPokemon(withId pokemonId : Int) throws -> PTPokemon
    {
        return try Disk.retrieve(kPTStorageDataSourceDiskPokemonLocation(withPokemonId: pokemonId), from: .documents, as: PTPokemon.self)
    }
    
    class func saveAllPokemonToDisk(_ allPokemonArray : [PTPokemon]) throws
    {
        try Disk.save(allPokemonArray, to: .documents, as: kPTStorageDataSourceDiskAllPokemonLocation)
        
        for pokemon in allPokemonArray
        {
            try Disk.save(pokemon, to: .documents, as: kPTStorageDataSourceDiskPokemonLocation(withPokemonId: pokemon.id))
        }
    }
    
    //MARK: - Trainers
    
    class func getAllTrainers() throws -> [PTTrainer]
    {
        return try Disk.retrieve(kPTStorageDataSourceDiskAllTrainersLocation, from: .documents, as: [PTTrainer].self)
    }
    
    class func saveTrainer(_ trainer : PTTrainer) throws
    {
        var allTrainers : [PTTrainer]
        
        if let loadedTrainers = try? self.getAllTrainers()
        {
            allTrainers = loadedTrainers
            
            var index : Int?
            
            for loopTrainer in allTrainers
            {
                if trainer.name.lowercased() == loopTrainer.name.lowercased()
                {
                    index = allTrainers.index(of: loopTrainer)
                    break
                }
            }
            
            if let index = index
            {
                //Remove old
                allTrainers.remove(at: index)
                //Insert new at old spot
                allTrainers.insert(trainer, at: index)
            }
            else
            {
                allTrainers.append(trainer)
            }
        }
        else
        {
            allTrainers = [trainer]
        }
        
        try Disk.save(allTrainers, to: .documents, as: kPTStorageDataSourceDiskAllTrainersLocation)
    }
}
