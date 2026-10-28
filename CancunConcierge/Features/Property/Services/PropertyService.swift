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
    
    func updateProperty(_ property: Property) async throws {

        guard let ownerId = Auth.auth().currentUser?.uid,
              ownerId == property.ownerId else {
            throw NSError(
                domain: "PropertyService",
                code: 403,
                userInfo: [
                    NSLocalizedDescriptionKey:
                        "You don't have permission to update this property."
                ]
            )
        }

        try await db.collection("properties")
            .document(property.id)
            .updateData([
                "name": property.name,
                "address": property.address,
                "wifiName": property.wifiName,
                "wifiPassword": property.wifiPassword,
                "checkIn": property.checkIn,
                "checkOut": property.checkOut
            ])
    }
    
    func getProperty(id: String) async throws -> Property? {

        guard let ownerId = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "PropertyService",
                code: 401,
                userInfo: [
                    NSLocalizedDescriptionKey: "User is not authenticated."
                ]
            )
        }

        let document = try await db.collection("properties")
            .document(id)
            .getDocument()

        guard let data = document.data() else {
            return nil
        }

        guard let propertyOwnerId = data["ownerId"] as? String,
              propertyOwnerId == ownerId,
              let name = data["name"] as? String,
              let address = data["address"] as? String,
              let wifiName = data["wifiName"] as? String,
              let wifiPassword = data["wifiPassword"] as? String,
              let checkIn = data["checkIn"] as? String,
              let checkOut = data["checkOut"] as? String else {
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
    
    func createProperty(_ property: Property) async throws {

        guard let ownerId = Auth.auth().currentUser?.uid else {
            throw NSError(
                domain: "PropertyService",
                code: 401,
                userInfo: [
                    NSLocalizedDescriptionKey: "User is not authenticated."
                ]
            )
        }

        guard property.ownerId == ownerId else {
            throw NSError(
                domain: "PropertyService",
                code: 403,
                userInfo: [
                    NSLocalizedDescriptionKey: "Invalid property owner."
                ]
            )
        }

        try await db.collection("properties")
            .addDocument(data: [
                "ownerId": ownerId,
                "name": property.name,
                "address": property.address,
                "wifiName": property.wifiName,
                "wifiPassword": property.wifiPassword,
                "checkIn": property.checkIn,
                "checkOut": property.checkOut
            ])
    }
}
