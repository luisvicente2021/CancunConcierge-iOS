//
//  UserService.swift
//  CancunConcierge
//
//  Created by usuario on 26/10/26.
//

import Foundation
import FirebaseFirestore

final class UserService {

    private let db = Firestore.firestore()

    func getUser(uid: String) async throws -> AppUser? {

        let document = try await db
            .collection("users")
            .document(uid)
            .getDocument()

        guard document.exists else {
            return nil
        }

        guard let data = document.data(),
              let roleString = data["role"] as? String,
              let role = UserRole(rawValue: roleString) else {
            return nil
        }

        return AppUser(
            id: document.documentID,
            role: role,
            propertyId: data["propertyId"] as? String
        )
    }
}
