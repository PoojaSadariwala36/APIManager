//
//  APIConfiguration.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation

struct APIConfiguration {
    static let shared = APIConfiguration()
    
    // MARK: - Base URLs
    let baseURL: String
    let timeout: TimeInterval
    
    private init() {
        // You can change this to point to different environments
        #if DEBUG
        self.baseURL = "https://jsonplaceholder.typicode.com"
        self.timeout = 30.0
        #else
        self.baseURL = "https://jsonplaceholder.typicode.com"
        self.timeout = 60.0
        #endif
    }
    
    // MARK: - Environment Configuration
    enum Environment: String, CaseIterable {
        case development = "development"
        case staging = "staging"
        case production = "production"
        
        var baseURL: String {
            switch self {
            case .development:
                return "https://jsonplaceholder.typicode.com"
            case .staging:
                return "https://staging-api.example.com"
            case .production:
                return "https://api.example.com"
            }
        }
        
        var timeout: TimeInterval {
            switch self {
            case .development:
                return 30.0
            case .staging:
                return 45.0
            case .production:
                return 60.0
            }
        }
        
        // MARK: - Environment Display Names
        var displayName: String {
            switch self {
            case .development:
                return "Development"
            case .staging:
                return "Staging"
            case .production:
                return "Production"
            }
        }
        
        var description: String {
            switch self {
            case .development:
                return "Local development environment with debug settings"
            case .staging:
                return "Staging environment for testing before production"
            case .production:
                return "Production environment with optimized settings"
            }
        }
    }
    
    // MARK: - Custom Configuration
    static func configure(environment: Environment) -> APIConfiguration {
        return APIConfiguration(
            baseURL: environment.baseURL,
            timeout: environment.timeout
        )
    }
    
    private init(baseURL: String, timeout: TimeInterval) {
        self.baseURL = baseURL
        self.timeout = timeout
    }
}

// MARK: - API Endpoints
extension APIConfiguration {
    struct Endpoints {
        static let users = "/users"
        static let posts = "/posts"
        static let comments = "/comments"
        static let albums = "/albums"
        static let photos = "/photos"
        static let todos = "/todos"
    }
}

// MARK: - Headers
extension APIConfiguration {
    struct Headers {
        static let contentType = "Content-Type"
        static let applicationJSON = "application/json"
        static let authorization = "Authorization"
        static let userAgent = "User-Agent"
        
        static var defaultHeaders: [String: String] {
            return [
                contentType: applicationJSON,
                userAgent: "SampleApp/1.0 (iOS)"
            ]
        }
    }
}