//
//  PropertyService.swift
//  CancunConcierge
//
//  Created by usuario on 27/10/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class PropertyService {

    private let db = Firestore.firestore()

    func getProperties() async throws -> [Property] {

        guard let ownerId = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "PropertyService",
                code: 401,
                userInfo: [
                    NSLocalizedDescriptionKey: "User is not authenticated."
                ]
            )
        }

        let snapshot = try await db.collection("properties")
            .whereField("ownerId", isEqualTo: ownerId)
            .getDocuments()

        return snapshot.documents.compactMap { document in

            let data = document.data()

            guard
                let name = data["name"] as? String,
                let address = data["address"] as? String,
                let wifiName = data["wifiName"] as? String,
                let wifiPassword = data["wifiPassword"] as? String,
                let checkIn = data["checkIn"] as? String,
                let checkOut = data["checkOut"] as? String,
                let propertyOwnerId = data["ownerId"] as? String
            else {
                return nil
            }

            return Property(
                id: document.documentID,
                ownerId: propertyOwnerId,
                name: name,
                address: address,
                wifiName: wifiName,
                wifiPassword: wifiPassword,
                checkIn: checkIn,
                checkOut: checkOut
            )
        }
    }
}
