//
//  SettingsView.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import SwiftUI

struct SettingsView: View {
    @State private var selectedEnvironment: APIConfiguration.Environment
    @State private var showingEnvironmentInfo = false
    
    init() {
        self._selectedEnvironment = State(initialValue: ConfigurationManager.shared.currentEnvironment)
    }
    
    var body: some View {
        NavigationView {
            List {
                if #available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *) {
                    Section("Network Status") {
                        NetworkStatusView()
                    }
                }
                
                Section("API Configuration") {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Base URL")
                            Text(APIConfiguration.shared.baseURL)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    HStack {
                        Image(systemName: "clock")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Timeout")
                            Text("\(Int(APIConfiguration.shared.timeout)) seconds")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                
                Section("Environment") {
                    ForEach(APIConfiguration.Environment.allCases, id: \.self) { environment in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(environment.displayName)
                                Text(environment.description)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            
                            Spacer()
                            
                            if selectedEnvironment == environment {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedEnvironment = environment
                            ConfigurationManager.shared.switchToEnvironment(environment)
                        }
                    }
                }
                
                Section("API Endpoints") {
                    EndpointRowView(
                        icon: "person.2",
                        title: "Users",
                        endpoint: APIConfiguration.Endpoints.users
                    )
                    
                    EndpointRowView(
                        icon: "doc.text",
                        title: "Posts",
                        endpoint: APIConfiguration.Endpoints.posts
                    )
                    
                    EndpointRowView(
                        icon: "bubble.left",
                        title: "Comments",
                        endpoint: APIConfiguration.Endpoints.comments
                    )
                    
                    EndpointRowView(
                        icon: "photo.on.rectangle",
                        title: "Albums",
                        endpoint: APIConfiguration.Endpoints.albums
                    )
                    
                    EndpointRowView(
                        icon: "photo",
                        title: "Photos",
                        endpoint: APIConfiguration.Endpoints.photos
                    )
                    
                    EndpointRowView(
                        icon: "checklist",
                        title: "Todos",
                        endpoint: APIConfiguration.Endpoints.todos
                    )
                }
                
                Section("Headers") {
                    ForEach(APIConfiguration.Headers.defaultHeaders.sorted(by: <), id: \.key) { key, value in
                        HStack {
                            Text(key)
                                .fontWeight(.medium)
                            Spacer()
                            Text(value)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.large)
            #endif
        }
    }
}

struct EndpointRowView: View {
    let icon: String
    let title: String
    let endpoint: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(title)
                Text(endpoint)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}
