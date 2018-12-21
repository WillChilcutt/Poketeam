//
//  PTLoadDataViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

class PTLoadDataViewController: UIViewController
{
    private let dataSource = PTPokeAPIDataSource()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        dataSource.getAllPokemon(withProgressBlock: { (progress, response) in
            
        }) {
            
        }
    }
}
