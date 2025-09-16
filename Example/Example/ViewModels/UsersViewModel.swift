//
//  UsersViewModel.swift
//  SampleApp
//
//  Created by APIManager on 15/09/25.
//

import Foundation
import Combine

@MainActor
class UsersViewModel: ObservableObject {
    @Published var users: [User] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var selectedUser: User?
    
    private let userService: UserServiceProtocol
    
    init(userService: UserServiceProtocol = UserService()) {
        self.userService = userService
    }
    
    func loadUsers() async {
        isLoading = true
        errorMessage = nil
        
        do {
            users = try await userService.fetchUsers()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    func selectUser(_ user: User) {
        selectedUser = user
    }
    
    func clearError() {
        errorMessage = nil
    }
}
