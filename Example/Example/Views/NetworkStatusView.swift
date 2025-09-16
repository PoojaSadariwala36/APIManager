//
//  NetworkStatusView.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import SwiftUI
import APIManager

@available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *)
struct NetworkStatusView: View {
    @StateObject private var reachability = NetworkReachability.shared
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: connectionIcon)
                .foregroundColor(connectionColor)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(connectionStatus)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(connectionType)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(backgroundColor)
        .cornerRadius(16)
    }
    
    private var connectionIcon: String {
        if reachability.isConnected {
            switch reachability.connectionType {
            case .wifi:
                return "wifi"
            case .cellular:
                return "antenna.radiowaves.left.and.right"
            case .ethernet:
                return "cable.connector"
            case .other:
                return "network"
            case .unknown:
                return "questionmark.circle"
            }
        } else {
            return "wifi.slash"
        }
    }
    
    private var connectionColor: Color {
        reachability.isConnected ? .green : .red
    }
    
    private var connectionStatus: String {
        reachability.isConnected ? "Connected" : "Disconnected"
    }
    
    private var connectionType: String {
        if reachability.isConnected {
            switch reachability.connectionType {
            case .wifi:
                return "Wi-Fi"
            case .cellular:
                return "Cellular"
            case .ethernet:
                return "Ethernet"
            case .other:
                return "Other"
            case .unknown:
                return "Unknown"
            }
        } else {
            return "No Connection"
        }
    }
    
    private var backgroundColor: Color {
        reachability.isConnected ? Color.green.opacity(0.1) : Color.red.opacity(0.1)
    }
}

@available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *)
struct NetworkStatusBanner: View {
    @StateObject private var reachability = NetworkReachability.shared
    
    var body: some View {
        if !reachability.isConnected {
            HStack {
                Image(systemName: "wifi.slash")
                    .foregroundColor(.white)
                
                Text("No Internet Connection")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.white)
                
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(Color.red)
            .transition(.move(edge: .top))
        }
    }
}

#Preview {
    VStack {
        NetworkStatusView()
        Spacer()
    }
    .padding()
}
