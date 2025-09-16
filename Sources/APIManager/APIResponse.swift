//
//  APIResponse.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public struct APIResponse<T> {
    public let data: T
    public let statusCode: Int
    public let headers: [String: String]
    public let url: URL?
    
    public init(data: T, statusCode: Int, headers: [String: String], url: URL?) {
        self.data = data
        self.statusCode = statusCode
        self.headers = headers
        self.url = url
    }
}

public struct APIResponseMetadata {
    public let statusCode: Int
    public let headers: [String: String]
    public let url: URL?
    
    public init(statusCode: Int, headers: [String: String], url: URL?) {
        self.statusCode = statusCode
        self.headers = headers
        self.url = url
    }
}
