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
    let id      : String
    let name    : String
    let url     : String
    
    lazy var spite : String = { return "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(id).png" }()
    
    private enum CodingKeys : String, CodingKey
    {
        case name = "name"
        case url = "url"
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = try container.decode(String.self, forKey: .name)
        
        self.url = try container.decode(String.self, forKey: .url)
        
        self.id = (self.url as NSString).lastPathComponent
    }
}
