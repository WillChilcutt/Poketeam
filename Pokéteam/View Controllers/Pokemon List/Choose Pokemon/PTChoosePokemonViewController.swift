//
//  PTChoosePokemonViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/22/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

protocol PTChoosePokemonViewControllerDelegate
{
    func handleUserChoosePokemon(_ pokemonArray : [PTPokemon])
    func handleUserCancelledChoosingPokemon()
}

class PTChoosePokemonViewController: PTListAllPokemonViewController
{
    private let pokemonToShow : [PTPokemon]?
    private let delegate : PTChoosePokemonViewControllerDelegate
    
    init(withDelegate delegate : PTChoosePokemonViewControllerDelegate, andPokemon pokemonArray : [PTPokemon]? = try? PTStorageDataSource.getAllPokemon())
    {
        self.delegate = delegate
        self.pokemonToShow = pokemonArray
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.tableView.allowsMultipleSelection = true
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancel))
        self.navigationItem.leftBarButtonItem = cancelButton
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.handleUserIsDoneSelectingPokemon))
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    override func getAllPokemon()
    {
        guard let pokemonToShow = self.pokemonToShow else { return }
        self.pokemonArray = pokemonToShow
        self.tableView.reloadData()
    }
    
    @objc private func cancel()
    {
        self.delegate.handleUserCancelledChoosingPokemon()
    }
    
    @objc private func handleUserIsDoneSelectingPokemon()
    {
        if let selectedIndexPaths = tableView.indexPathsForSelectedRows
        {
            var selectedPokemonArray : [PTPokemon] = []
            
            for indexPath in selectedIndexPaths
            {
                let pokemon = self.pokemonArray[indexPath.row]
                
                selectedPokemonArray.append(pokemon)
            }
            
            self.delegate.handleUserChoosePokemon(selectedPokemonArray)
        }
    }
}

//MARK: - UITableViewDataSource

extension PTChoosePokemonViewController
{
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        cell.selectionStyle = .none
        
        return cell
    }
}

//MARK: - UITableViewDelegate

extension PTChoosePokemonViewController
{
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .checkmark
        
        self.updateTitle()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath)
    {
        let cell = tableView.cellForRow(at: indexPath)
        
        cell?.accessoryType = .none
        
        self.updateTitle()
    }
    
    private func updateTitle()
    {
        if let selectedRowsCount = tableView.indexPathsForSelectedRows?.count
        {
            self.title = "\(selectedRowsCount) \(kPokemon) Selected"
        }
        else
        {
            self.title = "0 \(kPokemon) Selected"
        }
    }
}
