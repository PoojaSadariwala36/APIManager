//
//  ConfigurationExample.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import APIManager

class ConfigurationExample {
    
    // MARK: - Basic Usage
    static func basicUsage() {
        // Uses the default configuration
        let apiManager = APIManager.shared
        print("Using default configuration")
        print("Base URL: \(APIConfiguration.shared.baseURL)")
        print("Timeout: \(APIConfiguration.shared.timeout)")
    }
    
    // MARK: - Custom Configuration
    static func customConfiguration() {
        // Create a custom configuration for a specific environment
        let stagingConfig = APIConfiguration.configure(environment: .staging)
        print("Staging Configuration:")
        print("Base URL: \(stagingConfig.baseURL)")
        print("Timeout: \(stagingConfig.timeout)")
    }
    
    // MARK: - Environment Switching
    static func environmentSwitching() {
        let configManager = ConfigurationManager.shared
        
        // Switch to different environments
        configManager.switchToEnvironment(.development)
        print("Switched to development environment")
        
        configManager.switchToEnvironment(.staging)
        print("Switched to staging environment")
        
        configManager.switchToEnvironment(.production)
        print("Switched to production environment")
    }
    
    // MARK: - API Endpoint Usage
    static func endpointUsage() async {
        let userService = UserService()
        
        do {
            // All endpoints automatically use the common baseURL
            let users = try await userService.fetchUsers()
            print("Fetched \(users.count) users from \(APIConfiguration.shared.baseURL)")
            
            let posts = try await userService.fetchPosts()
            print("Fetched \(posts.count) posts from \(APIConfiguration.shared.baseURL)")
            
        } catch {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Custom Headers
    static func customHeadersExample() {
        let defaultHeaders = APIConfiguration.Headers.defaultHeaders
        print("Default Headers:")
        for (key, value) in defaultHeaders {
            print("  \(key): \(value)")
        }
    }
    
    // MARK: - Run All Examples
    static func runAllExamples() async {
        print("🚀 Running Configuration Examples...\n")
        
        basicUsage()
        print()
        
        customConfiguration()
        print()
        
        environmentSwitching()
        print()
        
        customHeadersExample()
        print()
        
        await endpointUsage()
        print()
        
        print("✅ All configuration examples completed!")
    }
}

// MARK: - Usage
// Uncomment to run examples
/*
Task {
    await ConfigurationExample.runAllExamples()
}
*/
