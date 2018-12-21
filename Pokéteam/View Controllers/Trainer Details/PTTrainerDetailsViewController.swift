//
//  PTTrainerDetailsViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

private let kPTTrainerDetailsViewControllerAddPokemonCellIdentifier = "kPTTrainerDetailsViewControllerAddPokemonCellIdentifier"

class PTTrainerDetailsViewController: UIViewController
{
    private let trainer         : PTTrainer
    private var sectionsArray   : [PTTableViewSection] = []
    
    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    init(withTrainer trainer : PTTrainer)
    {
        self.trainer = trainer
        super.init(nibName: String(describing: PTTrainerDetailsViewController.self), bundle: nil)
    }
    
    internal required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = trainer.name

        self.tableView.tableFooterView = UIView()
        self.tableView.register(UINib(nibName: kPTPokemonTableViewCellClassName, bundle: nil),
                                forCellReuseIdentifier: kPTPokemonTableViewCellClassName)
        
        self.setUpTableViewSections()
        self.tableView.reloadData()
    }
    
    private func setUpTableViewSections()
    {
        self.sectionsArray.removeAll()
        let pokemonSection = PTTableViewSection(name: kPokemon,
                                                rowObjects: self.trainer.pokemon,
                                                cellIdentifier:kPTPokemonTableViewCellClassName)
        self.sectionsArray.append(pokemonSection)
    }
}

//MARK: - UITableViewDataSource

extension PTTrainerDetailsViewController : UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return self.sectionsArray.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let section = self.sectionsArray[section]
        
        if section.name == kPokemon
        {
            return section.rowObjects.count + 1
        }
        
        return section.rowObjects.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        let section = self.sectionsArray[section]

        return section.name
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let section  = self.sectionsArray[indexPath.section]
        
        let cellIdentifier      : String
        var representedObject   : Any?
        
        if section.name == kPokemon && indexPath.row == section.rowObjects.count
        {
            cellIdentifier = kPTTrainerDetailsViewControllerAddPokemonCellIdentifier
        }
        else
        {
            cellIdentifier      = section.cellIdentifier
            representedObject   = section.rowObjects[indexPath.row]
        }
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default,
                                   reuseIdentifier: cellIdentifier)
        }
        
        if section.name == kPokemon
        {
            if  let cell = cell as? PTPokemonTableViewCell,
                let pokemon = representedObject as? PTPokemon
            {
                cell.setUp(withPokemon: pokemon)
            }
            else
            {
                cell?.textLabel?.text           = "Add a \(kPokemon)"
                cell?.textLabel?.textAlignment  = .center
            }
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 88.0
    }
}

extension PTTrainerDetailsViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = self.sectionsArray[indexPath.section]

        if section.name == kPokemon && indexPath.row == section.rowObjects.count
        {
            let listAllPokemonVC = PTListAllPokemonViewController()
            listAllPokemonVC.delegate = self
            
            let navController = UINavigationController(rootViewController: listAllPokemonVC)
            navController.navigationBar.isTranslucent = false
            
            let cancelButton = UIBarButtonItem(title: "Cancel",
                                               style: .plain,
                                               target: self,
                                               action: #selector(self.dismissListAllPokemon))
            listAllPokemonVC.navigationItem.leftBarButtonItem = cancelButton
            
            self.present(navController,
                         animated: true,
                         completion: nil)
        }
    }
    
    @objc private func dismissListAllPokemon()
    {
        self.presentedViewController?.dismiss(animated: true,
                                              completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]?
    {
        let section  = self.sectionsArray[indexPath.section]

        if section.name == kPokemon && indexPath.row != section.rowObjects.count
        {
            let removeAction = UITableViewRowAction(style: .destructive,
                                                    title: "Remove")
            { (action, indexPath) in
                
                guard let pokemon = section.rowObjects[indexPath.row] as? PTPokemon else { return }
                self.handleUserWantsToRemovePokemon(pokemon,
                                                    atIndexPath:indexPath)
            }
            
            return [removeAction]
        }
        
        return nil
    }
    
    private func handleUserWantsToRemovePokemon(_ pokemon : PTPokemon, atIndexPath indexPath : IndexPath)
    {
        self.trainer.pokemon.remove(at: indexPath.row)
        try? PTStorageDataSource.saveTrainer(trainer)
        self.setUpTableViewSections()
        
        self.tableView.beginUpdates()
        self.tableView.deleteRows(at: [indexPath], with: .left)
        self.tableView.endUpdates()
    }
}

//MARK: - PTListAllPokemonViewControllerDelegate

extension PTTrainerDetailsViewController : PTListAllPokemonViewControllerDelegate
{
    func handleUserSelected(pokemon: PTPokemon)
    {
        self.trainer.pokemon.append(pokemon)
        
        try? PTStorageDataSource.saveTrainer(trainer)
        
        self.setUpTableViewSections()
        self.tableView.reloadData()
        
        self.dismissListAllPokemon()
    }
}

