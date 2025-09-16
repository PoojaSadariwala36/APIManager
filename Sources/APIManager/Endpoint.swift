//
//  Endpoint.swift
//  APIManager
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import Foundation

public protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var body: Data? { get }
    var queryParameters: [String: String]? { get }
    var timeoutInterval: TimeInterval? { get }
}

public extension Endpoint {
    var url: URL? {
        guard var urlComponents = URLComponents(string: baseURL + path) else {
            return nil
        }
        
        if let queryParams = queryParameters, !queryParams.isEmpty {
            urlComponents.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
        }
        
        return urlComponents.url
    }
}
