//
//  Entries.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 16/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

struct FruitList {
    let id: Int
    let date: String
    let fruits: [FruitLite]
}

extension FruitList: Decodable {
    enum  FruitListCodingKeys: String, CodingKey {
        case id
        case date
        case fruits = "fruit"
    }

    init(from decoder: Decoder) throws {
        let fruitListContainer = try decoder.container(keyedBy: FruitListCodingKeys.self)
        
        id = try fruitListContainer.decode(Int.self, forKey: .id)
        date = try fruitListContainer.decode(String.self, forKey: .date)
        fruits = try fruitListContainer.decode([FruitLite].self, forKey: .fruits)
    }
}
