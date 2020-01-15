//
//  Fruit.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 15/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import Foundation

struct Fruit {
    let id: Int
    let type: String
    let vitamins: Int
    let imageUrl: String
}

extension Fruit: Decodable {
    enum FruitCodingKeys: String, CodingKey {
        case id
        case type
        case vitamins
        case imageUrl = "image"
    }
    
    init(from decoder: Decoder) throws {
        let fruitContainer = try decoder.container(keyedBy: FruitCodingKeys.self)
        
        id = try fruitContainer.decode(Int.self, forKey: .id)
        type = try fruitContainer.decode(String.self, forKey: .type)
        vitamins = try fruitContainer.decode(Int.self, forKey: .vitamins)
        imageUrl = try fruitContainer.decode(String.self, forKey: .imageUrl)
    }
}
