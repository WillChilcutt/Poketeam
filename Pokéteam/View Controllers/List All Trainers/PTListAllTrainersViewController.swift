//
//  PTListAllTrainersViewController.swift
//  Pokéteam
//
//  Created by Will Chilcutt on 12/19/18.
//  Copyright © 2018 Laoba Labs. All rights reserved.
//

import UIKit

private let kPTListAllTrainersViewControllerTrainerCellIdentifier = "kPTListAllTrainersViewControllerTrainerCellIdentifier"

class PTListAllTrainersViewController: UIViewController
{
    private let dataSource      : PTPokeAPIDataSource = PTPokeAPIDataSource()
    private var trainersArray   : [PTTrainer] = []
    
    private var addTrainerAction : UIAlertAction?

    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = "Trainers"
        
        self.setUpNavigationBarItem()
        
        self.loadAllTrainers()
    }
    
    private func setUpNavigationBarItem()
    {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                                 target: self,
                                                                 action: #selector(self.addNewTrainer))
    }
    
    private func loadAllTrainers()
    {
        self.trainersArray.removeAll()
        
        if let trainers = try? self.dataSource.getAllTrainers()
        {
            self.trainersArray.append(contentsOf: trainers)
        }

        self.tableView.reloadData()
    }
    
    @objc private func addNewTrainer()
    {
        let alertController = UIAlertController(title: "New Trainer",
                                                message: "Enter your new trainer's name:",
                                                preferredStyle: .alert)
        
        var trainersNameTextField : UITextField?
        
        alertController.addTextField
        { (textField) in
            trainersNameTextField = textField
            textField.placeholder = "Trainer's Name"
            textField.delegate = self
        }
        
        let addAction = UIAlertAction(title: "Add",
                                      style: .default,
                                      handler:
        { (action) in
            
            guard let name = trainersNameTextField?.text?.trimmingCharacters(in: .whitespacesAndNewlines) else { return }
            
            let trainer = PTTrainer(withName: name)
            
            try? self.dataSource.saveTrainer(trainer)
            
            self.loadAllTrainers()
        })
        
        addTrainerAction = addAction
        
        addAction.isEnabled = false
            
        alertController.addAction(addAction)
            
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel,
                                         handler:nil)
        alertController.addAction(cancelAction)
        
        self.present(alertController,
                     animated: true,
                     completion: nil)
    }
}

//MARK: - UITableViewDataSource

extension PTListAllTrainersViewController : UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.trainersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell  = tableView.dequeueReusableCell(withIdentifier: kPTListAllTrainersViewControllerTrainerCellIdentifier)
        
        if cell == nil
        {
            cell = UITableViewCell(style: .default, reuseIdentifier: kPTListAllTrainersViewControllerTrainerCellIdentifier)
        }
        
        let trainer = self.trainersArray[indexPath.row]
        
        cell?.textLabel?.text = trainer.name
        
        return cell!
    }
}

//MARK: - UITableViewDelegate

extension PTListAllTrainersViewController : UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath,
                              animated: true)
        
        let trainer = self.trainersArray[indexPath.row]

        print("Selected \(trainer.name)")
    }
}

extension PTListAllTrainersViewController : UITextFieldDelegate
{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool
    {
        if let textFieldText = textField.text
        {
            let trimmedFullString = (textFieldText as NSString).replacingCharacters(in: range, with: string).trimmingCharacters(in: .whitespacesAndNewlines)
            let notEmptyString = trimmedFullString != ""
            
            var trainerWithNameAlready = false
            
            for trainer in self.trainersArray
            {
                if trainer.name.lowercased() == trimmedFullString.lowercased()
                {
                    trainerWithNameAlready = true
                    break
                }
            }
            
            self.addTrainerAction?.isEnabled = notEmptyString == true && trainerWithNameAlready == false
        }
        
        return true
    }
}
