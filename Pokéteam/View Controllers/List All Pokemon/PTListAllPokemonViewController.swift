//
//  PTListAllPokemonViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/18/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

protocol PTListAllPokemonViewControllerDelegate
{
    func handleUserSelected(pokemon : PTPokemon)
}

class PTListAllPokemonViewController: UIViewController
{
    private var dataSource      : PTPokeAPIDataSource =  PTPokeAPIDataSource()
    private var pokemonArray    : [PTPokemon] = []
    
    var delegate : PTListAllPokemonViewControllerDelegate?
        
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    init()
    {
        super.init(nibName: nil , bundle: nil)
        self.title = "All \(kPokemon)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
                
        self.tableView.tableFooterView = UIView()
        
        self.tableView.register(UINib(nibName: kPTPokemonTableViewCellClassName, bundle: nil),
                                forCellReuseIdentifier: kPTPokemonTableViewCellClassName)
        
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
        var cell = tableView.dequeueReusableCell(withIdentifier: kPTPokemonTableViewCellClassName)
        
        if cell == nil
        {
            cell = PTPokemonTableViewCell(style: .default, reuseIdentifier: kPTPokemonTableViewCellClassName)
        }
        
        if let cell = cell as? PTPokemonTableViewCell
        {
            let pokemon = self.pokemonArray[indexPath.row]
            
            cell.setUp(withPokemon: pokemon)
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88.0
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

        self.delegate?.handleUserSelected(pokemon: pokemon)
    }
}
