//
//  UsersListView.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import SwiftUI

struct UsersListView: View {
    @StateObject private var viewModel = UsersViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView("Loading users...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let errorMessage = viewModel.errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.system(size: 50))
                            .foregroundColor(.red)
                        
                        Text("Error")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text(errorMessage)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                        
                        Button("Retry") {
                            Task {
                                await viewModel.loadUsers()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .padding()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List(viewModel.users) { user in
                        UserRowView(user: user) {
                            viewModel.selectUser(user)
                        }
                    }
                    .refreshable {
                        await viewModel.loadUsers()
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                await viewModel.loadUsers()
            }
            .sheet(item: $viewModel.selectedUser) { user in
                UserDetailView(userId: user.id)
            }
        }
    }
}

struct UserRowView: View {
    let user: User
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("@\(user.username)")
                    .font(.caption)
                    .foregroundColor(.blue)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 4)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    UsersListView()
}
