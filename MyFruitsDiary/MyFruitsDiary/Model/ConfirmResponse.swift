//
//  ConfirmResponse.swift
//  MyFruitsDiary
//
//  Created by Tomasz Idzi on 17/01/2020.
//  Copyright © 2020 Tomasz Idzi. All rights reserved.
//

import Foundation

struct ConfirmResponse {
    let message: String
    let code: Int
}

extension ConfirmResponse: Decodable {
    enum  ConfirmResponseCodingKeys: String, CodingKey {
        case message
        case code
    }

    init(from decoder: Decoder) throws {
        let confirmResponseContainer = try decoder.container(keyedBy: ConfirmResponseCodingKeys.self)
        
        message = try confirmResponseContainer.decode(String.self, forKey: .message)
        code = try confirmResponseContainer.decode(Int.self, forKey: .code)
    }
}
