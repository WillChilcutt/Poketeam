//
//  PTListAllPokemonViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/18/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

private let kPTListAllPokemonViewControllerCellIdentifier = "kPTListAllPokemonViewControllerCellIdentifier"

class PTListAllPokemonViewController: UIViewController
{
    private var dataSource      : PTPokeAPIDataSource =  PTPokeAPIDataSource()
    private var pokemonArray    : [PTPokemon] = []
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "All Pokémon"
        
        self.getAllPokemon()
    }
    
    private func getAllPokemon()
    {
        dataSource.getAllPokemon { (response) -> (Void) in
            switch response
            {
                case .failure(let error):
                    print("error getting pokemon: \(error)")
                    break
                case .success(let pokemonArray):
                    
                    DispatchQueue.main.async
                    {
                        self.pokemonArray.removeAll()
                        self.pokemonArray.append(contentsOf: pokemonArray)
                        
                        self.tableView.reloadData()
                    }
                    break
            }
        }
    }
}

//MARK: - UITableViewDataSource

extension PTListAllPokemonViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.pokemonArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: kPTListAllPokemonViewControllerCellIdentifier)
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: kPTListAllPokemonViewControllerCellIdentifier)
        }
        
        let pokemon = self.pokemonArray[indexPath.row]
        
        cell?.textLabel?.text = pokemon.name
        
        return cell!
    }
}

//MARK: - UITableViewDelegate

extension PTListAllPokemonViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        let pokemon = self.pokemonArray[indexPath.row]

        
        print("Selected \(pokemon.name)")
    }
}
