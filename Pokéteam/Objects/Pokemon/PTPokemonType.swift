//
//  PTPokemonType.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

struct PTPokemonType : Codable, Equatable
{
    let id      : String
    let url     : String
    let name    : String
    let slot    : Int
    
    private let type : PTInternalObject
    
    private enum CodingKeys : String, CodingKey
    {
        case slot
        case type
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.slot = try container.decode(Int.self,          forKey: .slot)
        self.type = try container.decode(PTInternalObject.self, forKey: .type)

        self.url    = self.type.url
        self.name   = self.type.name
        self.id     = (self.url as NSString).lastPathComponent
    }
}
