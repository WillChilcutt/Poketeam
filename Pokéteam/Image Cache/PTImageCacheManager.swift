//
//  PTImageCacheManager.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit
import AlamofireImage

class PTImageCacheManager: NSObject
{
    static let sharedInstance : PTImageCacheManager = PTImageCacheManager()
    
    let imageCache = AutoPurgingImageCache()
}
