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

struct PTPokemon : Codable
{
    let url     : String
    let name    : String
}
