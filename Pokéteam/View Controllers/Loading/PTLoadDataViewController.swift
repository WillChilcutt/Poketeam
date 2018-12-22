//
//  PTLoadDataViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/20/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

extension Notification.Name
{
    static var doneLoadingAllPokemon : Notification.Name { return .init("PTLoadDataViewControllerDoneLoadingAllPokemon") }
}

class PTLoadDataViewController: UIViewController
{
    private let dataSource = PTPokeAPIDataSource()
    
    //MARK: - IBOutlet
    @IBOutlet weak var progressView             : UIProgressView!
    @IBOutlet weak var progressPercentageLabel  : UILabel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        dataSource.getAllPokemon(withProgressBlock:
        { (progress, response) in
            
            DispatchQueue.main.async
            {
                self.progressView.setProgress(Float(progress), animated: true)
                
                self.progressPercentageLabel.text = "\(Int(progress * 100))%"
            }
        })
        { (allPokemon) in
            
            var sortedPokemon = allPokemon
                
            sortedPokemon.sortById()
            
            try? PTStorageDataSource.saveAllPokemonToDisk(sortedPokemon)
            
            PTPokeAPIDataSource.setHasCompletedFullDataLoad()
            
            NotificationCenter.default.post(name: .doneLoadingAllPokemon,
                                            object: nil)
        }
    }
}
