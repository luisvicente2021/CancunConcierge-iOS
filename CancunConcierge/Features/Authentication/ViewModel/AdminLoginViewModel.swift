//
//  AdminLoginViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 26/10/26.
//

import Foundation

@MainActor
final class AdminLoginViewModel: ObservableObject {
    
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isAuthenticated = false
    
    private let authService = AuthService()
    private let userService = UserService()
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            let firebaseUser = try await authService.signInAdmin(
                email: email,
                password: password
            )

            let appUser = try await userService.getUser(
                uid: firebaseUser.uid
            )

            guard appUser?.role == .admin else {
                isAuthenticated = false
                errorMessage = "You don't have administrator permissions."
                return
            }

            isAuthenticated = true
            print("✅ Admin login successful")

        } catch {
            isAuthenticated = false
            errorMessage = error.localizedDescription
        }
    }
}
