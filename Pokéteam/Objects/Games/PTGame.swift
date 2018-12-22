//
//  PTGame.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

struct PTGame : Codable, Equatable
{
    let id      : String
    let url     : String
    let name    : String
    
    private let version : PTInternalObject
    
    private enum CodingKeys : String, CodingKey
    {
        case version
    }
    
    public init(from decoder: Decoder) throws
    {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version = try container.decode(PTInternalObject.self, forKey: .version)
        
        self.url    = self.version.url
        self.name   = self.version.name
        self.id     = (self.url as NSString).lastPathComponent
    }
}
