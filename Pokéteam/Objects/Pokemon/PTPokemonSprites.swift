//
//  PTPokemonSprites.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

struct PTPokemonSprites : Codable, Equatable
{
    let back        : String?
    let front       : String
    let backShiny   : String?
    let frontShiny  : String
    
    private enum CodingKeys : String, CodingKey
    {
        case back       = "back_default"
        case front      = "front_default"
        case backShiny  = "back_shiny"
        case frontShiny = "front_shiny"
    }
}
