//
//  ConfigurationManager.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation

class ConfigurationManager {
    static let shared = ConfigurationManager()
    
    private init() {}
    
    // MARK: - Current Environment
    var currentEnvironment: APIConfiguration.Environment {
        #if DEBUG
        return .development
        #else
        return .production
        #endif
    }
    
    // MARK: - API Configuration
    var apiConfiguration: APIConfiguration {
        return APIConfiguration.configure(environment: currentEnvironment)
    }
    
    // MARK: - Environment Switching (for testing)
    func switchToEnvironment(_ environment: APIConfiguration.Environment) {
        // This would typically be used in testing or development
        // In a real app, you might want to persist this choice
        UserDefaults.standard.set(environment.rawValue, forKey: "selectedEnvironment")
    }
    
    func getStoredEnvironment() -> APIConfiguration.Environment? {
        guard let rawValue = UserDefaults.standard.string(forKey: "selectedEnvironment"),
              let environment = APIConfiguration.Environment(rawValue: rawValue) else {
            return nil
        }
        return environment
    }
}

