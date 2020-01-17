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
        self.title = "MyDiary"
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
    
    private func addEntry(with date: String) {
        networkManager.addEntry(date: date) { response, error in
            guard let fruitList = response else { return }
            self.entries?.append(fruitList)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private func removeEntry(at indexPath: IndexPath) {
        guard let entriesArray = self.entries else { return }
        let entry = entriesArray[indexPath.row]
        networkManager.removeSpecificEntries(entryId: entry.id) { response, error in
            if response?.code == 200 {
                self.entries?.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func removeAllEntries() {
        networkManager.removeAllEntries() { response, error in
            if response?.code == 200 {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    @IBAction func addEntry(_ sender: Any) {
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.frame = CGRect(x: 0, y: 15, width: 270, height: 200)
        
        let alertController = UIAlertController(title: "Add Entry", message: "\n\n\n\n\n\n\n\n", preferredStyle: UIAlertController.Style.alert)
        alertController.view.addSubview(datePicker)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let selectedDate = dateFormatter.string(from: datePicker.date)
            self.addEntry(with: selectedDate)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion:{})
    }
    
    @IBAction func removeAll(_ sender: Any) {
        removeAllEntries()
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            removeEntry(at: indexPath)
        }
    }
}
