//
//  Encodable+Extensions.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public extension Encodable {
    func toJSONData() -> Data? {
        try? JSONEncoder().encode(self)
    }
}
