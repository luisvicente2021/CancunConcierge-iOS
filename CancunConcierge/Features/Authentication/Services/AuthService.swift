//
//  AuthService.swift
//  CancunConcierge
//
//  Created by luisr on 19/10/26.
//
import Foundation
import FirebaseAuth

final class AuthService {
    
    func signInAnonymously() async throws -> String {
        
        let result = try await Auth.auth().signInAnonymously()
        return result.user.uid
    }
    
    func signInAdmin(email: String, password: String) async throws -> User {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        
        return result.user
    }
    
    func signOut() throws {
        try Auth.auth().signOut()
    }
}
