//
//  PTPokemonTableViewCell.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

let kPTPokemonTableViewCellClassName = String(describing: PTPokemonTableViewCell.self)

class PTPokemonTableViewCell: UITableViewCell
{
    var pokemon : PTPokemon?
    @IBOutlet weak var spriteImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUp(withPokemon pokemon : PTPokemon)
    {
        self.pokemon = pokemon
        
        guard var pokemon = self.pokemon else { return }
        
        self.nameLabel.text = pokemon.name
        
        if let url = URL(string: pokemon.spite)
        {
            let urlRequest = URLRequest(url: url)
            
            if let fetchedImage = PTImageCacheManager.sharedInstance.imageCache.image(for: urlRequest)
            {
                self.spriteImageView.image = fetchedImage
                print("Loaded cached image")
            }
            else
            {
                print("Requesting new image")
                
                Alamofire.request(url).responseImage
                { (response) in
                    DispatchQueue.main.async
                    {
                        if  let image = response.result.value,
                            let cellPokemon = self.pokemon
                        {
                            if cellPokemon == pokemon
                            {
                                self.spriteImageView.image = image
                                self.setNeedsLayout()
                            }
                            
                            PTImageCacheManager.sharedInstance.imageCache.add(image, for: urlRequest)
                        }
                    }
                }
            }
        }
    }
}
