//
//  FruitEndPoint.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 15/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import Foundation

enum NetworkEnvironment {
    case production
}

public enum FruitAPI {
    case availableFruits
    case currentEntries
    case removeAllCurrentEntries
    case removeSpecificEntry(entryId: Int)
    case addEntry(date: String)
    case updateEntry(entryId: Int, fruitId: Int, nrOfFruit: Int)
}

extension FruitAPI: EndPointType {
        
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://fruitdiary.test.themobilelife.com/api/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .availableFruits:
            return "fruit"
        case .currentEntries:
            return "entries"
        case .removeAllCurrentEntries:
            return "entries"
        case .removeSpecificEntry(let id):
            return "entry/\(id)"
        case .addEntry:
            return "entries"
        case .updateEntry(let entryId, let fruitId, let nrOfFruit):
            return "entry/\(entryId)/fruit/\(fruitId)?amount=\(nrOfFruit)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .availableFruits,
             .currentEntries:
            return .get
        case .removeAllCurrentEntries,
             .removeSpecificEntry:
            return .delete
        case .addEntry,
             .updateEntry:
            return .post
        }
    }
    
    var task: HTTPTask {
        switch self {
        case .addEntry(let date):
            return .requestParameters(bodyParameters: ["date":date], urlParameters: nil)
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
}
