//
//  ExampleApp.swift
//  Example
//
//  Created by Pooja Sadariwala on 15/09/25.
//

import SwiftUI

@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
    }
}

struct MainTabView: View {
    var body: some View {
        ZStack {
            
            TabView {
                UsersListView()
                    .tabItem {
                        Image(systemName: "person.2")
                        Text("Users")
                    }
                
                SettingsView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("Settings")
                    }
            }
            
            VStack {
                if #available(iOS 12.0, macOS 10.14, watchOS 5.0, tvOS 12.0, *) {
                    NetworkStatusBanner()
                }
                Spacer()
            }
        }
    }
}
