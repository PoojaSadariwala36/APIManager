//
//  NetworkReachabilityExample.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import APIManager

@available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *)
class NetworkReachabilityExample {
    
    // MARK: - Basic Network Status Check
    static func basicNetworkCheck() async {
        print("🔍 Checking network connectivity...")
        
        let isConnected = await NetworkReachability.shared.checkConnectivity()
        print("Network Status: \(isConnected ? "✅ Connected" : "❌ Disconnected")")
        
        if isConnected {
            print("Connection Type: \(NetworkReachability.shared.connectionType)")
        }
    }
    
    // MARK: - Reactive Network Monitoring
    static func setupNetworkMonitoring() {
        print("📡 Setting up network monitoring...")
        
        // The NetworkReachability.shared is already an ObservableObject
        // In a real app, you would observe it in your SwiftUI views
        print("Network monitoring is now active")
        print("Current status: \(NetworkReachability.shared.isConnected ? "Connected" : "Disconnected")")
    }
    
    // MARK: - API Request with Network Check
    static func apiRequestWithNetworkCheck() async {
        print("🌐 Making API request with network check...")
        
        let userService = UserService()
        
        do {
            // This will automatically check network connectivity
            let users = try await userService.fetchUsers()
            print("✅ Successfully fetched \(users.count) users")
        } catch APIError.networkUnavailable {
            print("❌ Network is not available")
        } catch {
            print("❌ Other error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Network Status Information
    static func displayNetworkInfo() {
        print("📊 Network Information:")
        print("  Connected: \(NetworkReachability.shared.isConnected)")
        print("  Type: \(NetworkReachability.shared.connectionType)")
        print("  Is WiFi: \(NetworkReachability.shared.isWiFi)")
        print("  Is Cellular: \(NetworkReachability.shared.isCellular)")
        print("  Is Reachable: \(NetworkReachability.shared.isReachable)")
    }
    
    // MARK: - Simulate Network Changes
    static func simulateNetworkChanges() {
        print("🔄 Simulating network state changes...")
        
        // In a real app, you would test this by:
        // 1. Turning off WiFi
        // 2. Turning off cellular data
        // 3. Going to airplane mode
        // 4. Reconnecting to network
        
        print("To test network reachability:")
        print("1. Turn off WiFi and cellular data")
        print("2. Try making an API request")
        print("3. Turn network back on")
        print("4. Observe the network status changes")
    }
    
    // MARK: - Error Handling with Network Status
    static func errorHandlingExample() async {
        print("⚠️ Demonstrating error handling with network status...")
        
        let userService = UserService()
        
        do {
            let users = try await userService.fetchUsers()
            print("✅ Success: \(users.count) users fetched")
        } catch APIError.networkUnavailable {
            print("❌ Network Error: No internet connection available")
            print("💡 Suggestion: Check your network settings and try again")
        } catch APIError.serverError(let statusCode) {
            print("❌ Server Error: HTTP \(statusCode)")
            print("💡 Suggestion: Server might be down, try again later")
        } catch APIError.decodingError {
            print("❌ Decoding Error: Failed to parse response")
            print("💡 Suggestion: Check API response format")
        } catch {
            print("❌ Unknown Error: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Run All Examples
    static func runAllExamples() async {
        print("🚀 Running Network Reachability Examples...\n")
        
        await basicNetworkCheck()
        print()
        
        setupNetworkMonitoring()
        print()
        
        displayNetworkInfo()
        print()
        
        await apiRequestWithNetworkCheck()
        print()
        
        await errorHandlingExample()
        print()
        
        simulateNetworkChanges()
        print()
        
        print("✅ All network reachability examples completed!")
    }
}

// MARK: - Usage
// Uncomment to run examples
/*
Task {
    await NetworkReachabilityExample.runAllExamples()
}
*/
