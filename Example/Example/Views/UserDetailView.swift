//
//  UserDetailView.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import SwiftUI

struct UserDetailView: View {
    let userId: Int
    @StateObject private var viewModel: UserDetailViewModel
    @Environment(\.dismiss) private var dismiss
    
    init(userId: Int) {
        self.userId = userId
        self._viewModel = StateObject(wrappedValue: UserDetailViewModel(userId: userId))
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading user details...")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else if let errorMessage = viewModel.errorMessage {
                        ErrorView(message: errorMessage) {
                            Task {
                                await viewModel.loadUser()
                            }
                        }
                    } else if let user = viewModel.user {
                        UserInfoSection(user: user)
                        
                        Divider()
                        
                        PostsSection(
                            posts: viewModel.posts,
                            isLoading: viewModel.isLoadingPosts,
                            onLoadPosts: {
                                Task {
                                    await viewModel.loadUserPosts()
                                }
                            }
                        )
                    }
                }
                .padding()
            }
            .navigationTitle("User Details")
            #if os(iOS)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            #else
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
            #endif
            .task {
                await viewModel.loadUser()
            }
        }
    }
}

struct UserInfoSection: View {
    let user: User
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(user.name)
                .font(.title2)
                .fontWeight(.bold)
            
            InfoRow(icon: "envelope", title: "Email", value: user.email)
            InfoRow(icon: "at", title: "Username", value: "@\(user.username)")
            
            if let phone = user.phone {
                InfoRow(icon: "phone", title: "Phone", value: phone)
            }
            
            if let website = user.website {
                InfoRow(icon: "globe", title: "Website", value: website)
            }
            
            if let address = user.address {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "location")
                            .foregroundColor(.blue)
                        Text("Address")
                            .fontWeight(.medium)
                    }
                    
                    Text("\(address.street), \(address.suite)")
                    Text("\(address.city), \(address.zipcode)")
                        .foregroundColor(.secondary)
                }
            }
            
            if let company = user.company {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "building.2")
                            .foregroundColor(.blue)
                        Text("Company")
                            .fontWeight(.medium)
                    }
                    
                    Text(company.name)
                    Text(company.catchPhrase)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

struct InfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(value)
                    .font(.subheadline)
            }
            
            Spacer()
        }
    }
}

struct PostsSection: View {
    let posts: [Post]
    let isLoading: Bool
    let onLoadPosts: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Posts")
                    .font(.headline)
                
                Spacer()
                
                if !posts.isEmpty {
                    Text("\(posts.count) posts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if isLoading {
                ProgressView("Loading posts...")
                    .frame(maxWidth: .infinity)
            } else if posts.isEmpty {
                Button("Load Posts") {
                    onLoadPosts()
                }
                .buttonStyle(.borderedProminent)
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(posts) { post in
                        PostRowView(post: post)
                    }
                }
            }
        }
    }
}

struct PostRowView: View {
    let post: Post
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(post.title)
                .font(.headline)
                .lineLimit(2)
            
            Text(post.body)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .lineLimit(3)
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}

struct ErrorView: View {
    let message: String
    let onRetry: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "exclamationmark.triangle")
                .font(.system(size: 50))
                .foregroundColor(.red)
            
            Text("Error")
                .font(.title2)
                .fontWeight(.bold)
            
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            Button("Retry") {
                onRetry()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    UserDetailView(userId: 1)
}
