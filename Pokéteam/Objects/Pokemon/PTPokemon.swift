//
//  PTPokemon.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import Foundation

struct PTPokemonResponse : Codable
{
    let results : [PTPokemon]
}

struct PTPokemon : Codable, Equatable
{
    let id                  : Int
    let name                : String
    let stats               : [PTPokemonStat]
    let types               : [PTPokemonType]
    let height              : Int
    let weight              : Int
    let sprites             : PTPokemonSprites
    let abilities           : [PTPokemonAbility]
    let baseExperience      : Int
    let gamesAvailableIn    : [PTGame]
    
    private enum CodingKeys : String, CodingKey
    {
        case id
        case name
        case stats
        case types
        case height
        case weight
        case sprites
        case abilities 
        case baseExperience     = "base_experience"
        case gamesAvailableIn   = "game_indices"
    }
}
