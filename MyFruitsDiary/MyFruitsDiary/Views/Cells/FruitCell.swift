//
//  FruitCell.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 17/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import UIKit

class FruitCell: UITableViewCell {
    
    // MARK: - Properties
    var networkManager = NetworkManager()
    var fruits: [Fruit]?
    
    // MARK: - Outlets
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    func setupInterface(with fruit: FruitLite) {
        self.nameLabel.text = fruit.type.capitalized
        self.amountLabel.text = "Amount: \(fruit.amount)"
        
        if let fruit = self.fruits?.filter({ $0.id == fruit.id }).first {
            networkManager.downloadImage(path: fruit.imageUrl) { response, error in
                guard let image = response else { return }
                DispatchQueue.main.async {
                    self.picture.image = UIImage(data: image)
                }
            }
        }
    }
    
    func setupInterface(with fruit: Fruit) {
        self.nameLabel.text = fruit.type.capitalized
        self.amountLabel.text = "Vitamins: \(fruit.vitamins)"
        networkManager.downloadImage(path: fruit.imageUrl) { response, error in
            guard let image = response else { return }
            DispatchQueue.main.async {
                self.picture.image = UIImage(data: image)
            }
        }
    }
}
