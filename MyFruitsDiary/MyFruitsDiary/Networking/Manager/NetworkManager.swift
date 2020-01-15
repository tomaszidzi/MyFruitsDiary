//
//  NetworkManager.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 15/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

struct NetworkManager {
    static let environment: NetworkEnvironment = .production
    private let router = Router<FruitAPI>()
}
