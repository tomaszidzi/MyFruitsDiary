//
//  EntryDetailViewController.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 17/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import UIKit

enum DetailViewType {
    case infoView
    case addView
}

protocol AddFruitDelegate: class {
    func fruitDidAdd(with fruit: Fruit, amount: Int)
}

class EntryDetailViewController: UIViewController {
    // MARK: - Properties
    var networkManager = NetworkManager()
    
    // MARK: - Properties
    var fruits: [Fruit]?
    var entry: FruitList? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    var viewType = DetailViewType.infoView
    weak var delegate: AddFruitDelegate?
    
    // MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - ViewController life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = entry?.date
    }
    
    // MARK: - Actions
    @IBAction func addFruit(_ sender: Any) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        
        if let vc = storyboard.instantiateViewController(identifier: "EntryDetailViewController") as? EntryDetailViewController {
            vc.delegate = self
            vc.fruits = self.fruits
            vc.viewType = DetailViewType.addView
            self.present(vc, animated: true, completion: nil)
            
        }
    }
    
    // MARK: - Requests
    private func updateEntry(entryId: Int, fruitId: Int, nrOfFruit: Int) {
        networkManager.updateEntry(entryId: entryId, fruitId: fruitId, nrOfFruit: nrOfFruit) { response, error in
            if response?.code == 200 {
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}

// MARK: - TableView
extension EntryDetailViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewType == DetailViewType.infoView ? self.entry?.fruits.count ?? 0 : self.fruits?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FruitCell") as? FruitCell
            else { return UITableViewCell() }
        
        switch self.viewType {
        case .addView:
            if let dataSource = self.fruits {
                let fruit = dataSource[indexPath.row]
                cell.setupInterface(with: fruit)
                cell.fruits = self.fruits
            }
        case .infoView:
            if let dataSource = self.entry {
                let fruit = dataSource.fruits[indexPath.row]
                cell.setupInterface(with: fruit)
                cell.fruits = self.fruits
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: "Add amount of fruit.",
                                      message: nil,
                                      preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned alert] (action) in
            if let textField = alert.textFields?.first,
                let text = textField.text, let amount = Int(text), let dataSource = self.fruits {
                switch self.viewType {
                case .addView:
                    self.delegate?.fruitDidAdd(with: dataSource[indexPath.row], amount: amount)
                    self.dismiss(animated: true, completion: nil)
                case .infoView:
                    guard let selectedEntry = self.entry, let dataSource = self.entry else { return }
                    self.updateEntry(entryId: selectedEntry.id, fruitId: dataSource.fruits[indexPath.row].id, nrOfFruit: amount)
                }
                
                
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - AddFruitDelegate
extension EntryDetailViewController: AddFruitDelegate {
    func fruitDidAdd(with fruit: Fruit, amount: Int) {
        guard let selectedEntry = self.entry else { return }
        self.updateEntry(entryId: selectedEntry.id, fruitId: fruit.id, nrOfFruit: amount)
    }
}
