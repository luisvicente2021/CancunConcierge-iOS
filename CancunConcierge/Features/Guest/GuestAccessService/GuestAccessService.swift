//
//  GuestAccessService.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import Foundation
import FirebaseAuth
import FirebaseFunctions

final class GuestAccessService {

    private let functions = Functions.functions()

    func signOutCurrentUser() throws {
        try Auth.auth().signOut()
    }

    func signInGuest() async throws {
        if let currentUser = Auth.auth().currentUser {
            if currentUser.isAnonymous {
                return
            }

            throw NSError(
                domain: "GuestAccessService",
                code: 403,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "An administrator session is active. Please sign out before accessing as a guest."
                ]
            )
        }

        _ = try await Auth.auth().signInAnonymously()
    }


    func redeemAccessCode(_ accessCode: String) async throws -> String {

        guard Auth.auth().currentUser != nil else {
            throw NSError(
                domain: "GuestAccessService",
                code: 401,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "You must be signed in to access a property."
                ]
            )
        }

        let normalizedCode = accessCode
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .uppercased()

        let result = try await functions
            .httpsCallable("redeemGuestAccessCode")
            .call([
                "accessCode": normalizedCode
            ])

        guard let data = result.data as? [String: Any],
              let propertyId = data["propertyId"] as? String else {
            throw NSError(
                domain: "GuestAccessService",
                code: 500,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "Invalid response from the server."
                ]
            )
        }

        return propertyId
    }
}
