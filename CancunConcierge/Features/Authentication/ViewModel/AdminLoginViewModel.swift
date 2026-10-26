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
    
    func signIn() async {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Enter your email and password."
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        defer { isLoading = false }
        
        do {
            _ = try await authService.signInAdmin(
                email: email,
                password: password
            )
            
            isAuthenticated = true
            
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
