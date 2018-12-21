//
//  PTPokemonAbility.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

struct PTPokemonAbility : Codable, Equatable
{
    let id          : String
    let url         : String
    let name        : String
    let slot        : Int
    let isHidden    : Bool
    
    private let ability : PTInternalObject
    
    private enum CodingKeys : String, CodingKey
    {
        case slot
        case ability 
        case isHidden   = "is_hidden"
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.slot       = try container.decode(Int.self,    forKey: .slot)
        self.ability    = try container.decode(PTInternalObject.self, forKey: .ability)
        self.isHidden   = try container.decode(Bool.self,   forKey: .isHidden)
        
        self.url        = self.ability.url
        self.name       = self.ability.name
        self.id = (self.url as NSString).lastPathComponent
    }
}
