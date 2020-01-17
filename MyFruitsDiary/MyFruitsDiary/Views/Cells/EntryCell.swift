//
//  EntryCell.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 17/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import UIKit

class EntryCell: UITableViewCell {
    // MARK: - Properties
    var fruits: [Fruit]?

    // MARK: - Outlets
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var fruitsLabel: UILabel!
    @IBOutlet weak var vitaminsLabel: UILabel!
        
    func setupInterfacte(with entry: FruitList) {
        dateLabel.text = "Date: \(entry.date)"
        fruitsLabel.text = "Number of fruits: \(entry.fruits.count)"
        let vitamins = entry.fruits.map { $0.amount * getVitamin(for: $0.id) }.reduce(0, +)
        vitaminsLabel.text = "Total number of vitamins: \(vitamins)"
    }
    
    private func getVitamin(for fruitId: Int) -> Int {
        return fruits?.filter{ $0.id == fruitId }.first?.vitamins ?? 0
    }
}
