//
//  PTPokemonStat.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

struct PTPokemonStat : Codable, Equatable
{
    let id          : String
    let url         : String
    let name        : String
    let effort      : Int
    let baseStat    : Int
    
    private let stat : PTInternalObject
    
    private enum CodingKeys : String, CodingKey
    {
        case stat
        case effort
        case baseStat   = "base_stat"
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
                
        self.stat       = try container.decode(PTInternalObject.self, forKey: .stat)
        self.effort     = try container.decode(Int.self,        forKey: .effort)
        self.baseStat   = try container.decode(Int.self,        forKey: .baseStat)
        
        self.url    = self.stat.url
        self.name   = self.stat.name
        self.id     = (self.url as NSString).lastPathComponent
    }
}
