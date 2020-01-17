//
//  MyDiaryViewController.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 17/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import UIKit

class MyDiaryViewController: UIViewController {
    // MARK: - Properties
    var networkManager = NetworkManager()
    
    var fruits: [Fruit]?
    var entries: [FruitList]?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "My Diary"
        
        getFruit()
    }

    // MARK: - Requests
    private func getFruit() {
        networkManager.getFruits() { fruits, error in
            self.fruits = fruits
            self.getEntries()
        }
    }
    
    private func getEntries() {
        networkManager.getEntries() { entries, error in
            self.entries = entries
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView
extension MyDiaryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EntryCell") as? EntryCell,
        let dataSource = entries else {
            return UITableViewCell()
        }
        cell.fruits = self.fruits
        cell.setupInterfacte(with: dataSource[indexPath.row])
        
        return cell
    }
    
    
}
