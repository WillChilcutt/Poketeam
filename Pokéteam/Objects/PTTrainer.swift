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
    let name    : String
    var pokemon : [PTPokemon] = []
    
    init(withName name : String)
    {
        self.name = name
        super.init()
    }
}
