//
//  UserDetailViewModel.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import Combine

@MainActor
class UserDetailViewModel: ObservableObject {
    @Published var user: User?
    @Published var posts: [Post] = []
    @Published var isLoading = false
    @Published var isLoadingPosts = false
    @Published var errorMessage: String?
    
    private let userService: UserServiceProtocol
    private let userId: Int
    
    init(userId: Int, userService: UserServiceProtocol = UserService()) {
        self.userId = userId
        self.userService = userService
    }
    
    func loadUser() async {
        isLoading = true
        errorMessage = nil
        
        do {
            user = try await userService.fetchUser(id: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func loadUserPosts() async {
        isLoadingPosts = true
        
        do {
            posts = try await userService.fetchUserPosts(userId: userId)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoadingPosts = false
    }
    
    func clearError() {
        errorMessage = nil
    }
}
