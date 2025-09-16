//
//  UserService.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import APIManager

protocol UserServiceProtocol {
    func fetchUsers() async throws -> [User]
    func fetchUser(id: Int) async throws -> User
    func fetchUserPosts(userId: Int) async throws -> [Post]
    func fetchPosts() async throws -> [Post]
    func fetchPost(id: Int) async throws -> Post
    func fetchPostComments(postId: Int) async throws -> [Comment]
}

class UserService: UserServiceProtocol {
    private let apiManager: APIManager
    
    init(apiManager: APIManager = APIManager.shared) {
        self.apiManager = apiManager
    }
    
    // MARK: - User Methods
    func fetchUsers() async throws -> [User] {
        let endpoint = UsersEndpoint()
        return try await apiManager.request(endpoint, as: [User].self)
    }
    
    func fetchUser(id: Int) async throws -> User {
        let endpoint = UserEndpoint(userId: id)
        return try await apiManager.request(endpoint, as: User.self)
    }
    
    func fetchUserPosts(userId: Int) async throws -> [Post] {
        let endpoint = UserPostsEndpoint(userId: userId)
        return try await apiManager.request(endpoint, as: [Post].self)
    }
    
    // MARK: - Post Methods
    func fetchPosts() async throws -> [Post] {
        let endpoint = PostsEndpoint()
        return try await apiManager.request(endpoint, as: [Post].self)
    }
    
    func fetchPost(id: Int) async throws -> Post {
        let endpoint = PostEndpoint(postId: id)
        return try await apiManager.request(endpoint, as: Post.self)
    }
    
    func fetchPostComments(postId: Int) async throws -> [Comment] {
        let endpoint = PostCommentsEndpoint(postId: postId)
        return try await apiManager.request(endpoint, as: [Comment].self)
    }
}
