//
//  Endpoints.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import APIManager

// MARK: - Base Endpoint Protocol
protocol APIEndpoint: Endpoint {
    var apiPath: String { get }
}

extension APIEndpoint {
    var baseURL: String { APIConfiguration.shared.baseURL }
    var path: String { apiPath }
    var headers: [String: String]? { APIConfiguration.Headers.defaultHeaders }
    var timeoutInterval: TimeInterval? { APIConfiguration.shared.timeout }
}

// MARK: - User Endpoints
struct UsersEndpoint: APIEndpoint {
    var apiPath: String { APIConfiguration.Endpoints.users }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}

struct UserEndpoint: APIEndpoint {
    let userId: Int
    
    var apiPath: String { "\(APIConfiguration.Endpoints.users)/\(userId)" }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}

struct UserPostsEndpoint: APIEndpoint {
    let userId: Int
    
    var apiPath: String { APIConfiguration.Endpoints.posts }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { ["userId": "\(userId)"] }
}

// MARK: - Post Endpoints
struct PostsEndpoint: APIEndpoint {
    var apiPath: String { APIConfiguration.Endpoints.posts }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}

struct PostEndpoint: APIEndpoint {
    let postId: Int
    
    var apiPath: String { "\(APIConfiguration.Endpoints.posts)/\(postId)" }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}

// MARK: - Comment Endpoints
struct PostCommentsEndpoint: APIEndpoint {
    let postId: Int
    
    var apiPath: String { "\(APIConfiguration.Endpoints.posts)/\(postId)/comments" }
    var method: HTTPMethod { .GET }
    var body: Data? { nil }
    var queryParameters: [String: String]? { nil }
}
