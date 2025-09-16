//
//  NetworkReachability.swift
//  APIManager
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import Network

@available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *)
public class NetworkReachability: ObservableObject {
    public static let shared = NetworkReachability()
    
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkReachability")
    
    @Published public private(set) var isConnected = false
    @Published public private(set) var connectionType: ConnectionType = .unknown
    
    public enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case other
        case unknown
    }
    
    private init() {
        startMonitoring()
    }
    
    deinit {
        stopMonitoring()
    }
    
    private func startMonitoring() {
        monitor.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = path.status == .satisfied
                self?.connectionType = self?.getConnectionType(from: path) ?? .unknown
            }
        }
        monitor.start(queue: queue)
    }
    
    private func stopMonitoring() {
        monitor.cancel()
    }
    
    private func getConnectionType(from path: NWPath) -> ConnectionType {
        if path.usesInterfaceType(.wifi) {
            return .wifi
        } else if path.usesInterfaceType(.cellular) {
            return .cellular
        } else if path.usesInterfaceType(.wiredEthernet) {
            return .ethernet
        } else if path.usesInterfaceType(.other) {
            return .other
        } else {
            return .unknown
        }
    }
    
    public func checkConnectivity() async -> Bool {
        return await withCheckedContinuation { continuation in
            let currentPath = monitor.currentPath
            let isConnected = currentPath.status == .satisfied
            continuation.resume(returning: isConnected)
        }
    }
}

// MARK: - Legacy Support
@available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *)
public extension NetworkReachability {
    var isReachable: Bool {
        return isConnected
    }
    
    var isWiFi: Bool {
        return connectionType == .wifi
    }
    
    var isCellular: Bool {
        return connectionType == .cellular
    }
}
