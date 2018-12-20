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
    private var trainersArray : [PTTrainer] = []

    //MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.loadAllTrainers()
    }
    
    private func loadAllTrainers()
    {
        self.trainersArray.removeAll()
        
        
        
        self.tableView.reloadData()
    }
}

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
