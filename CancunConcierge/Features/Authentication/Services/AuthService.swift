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
    
}
