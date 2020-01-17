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
    case downloadImage(path: String)
}

extension FruitAPI: EndPointType {
        
    var environmentBaseURL: String {
        switch NetworkManager.environment {
        case .production: return "https://fruitdiary.test.themobilelife.com/"
        }
    }
    
    var baseURL: URL {
        guard let url = URL(string: environmentBaseURL) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .availableFruits:
            return "api/fruit"
        case .currentEntries:
            return "api/entries"
        case .removeAllCurrentEntries:
            return "api/entries"
        case .removeSpecificEntry(let id):
            return "api/entry/\(id)"
        case .addEntry:
            return "api/entries"
        case .updateEntry(let entryId, let fruitId, _):
            return "api/entry/\(entryId)/fruit/\(fruitId)"
        case .downloadImage(let path):
            return "\(path)"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        case .availableFruits,
             .currentEntries,
             .downloadImage:
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
        case .updateEntry(_, _, let nrOfFruit):
            return .requestParameters(bodyParameters: nil, urlParameters: ["amount":nrOfFruit])
        default:
            return .request
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        case .addEntry,
             .updateEntry:
            return ["Content-Type":"application/json"]
        default:
            return nil
        }
    }
}
