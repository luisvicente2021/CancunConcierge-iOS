//
//  AnnouncementService.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import Foundation
import FirebaseFirestore

final class AnnouncementService {

    private let db = Firestore.firestore()

    func deactivateAnnouncement(id: String) async throws {
        try await db.collection("announcements")
            .document(id)
            .updateData([
                "isActive": false
            ])
    }

    // Crear un anuncio para una propiedad
    func createAnnouncement(
        propertyId: String,
        title: String,
        message: String
    ) async throws {

        let document = db.collection("announcements").document()

        try await document.setData([
            "propertyId": propertyId,
            "title": title,
            "message": message,
            "createdAt": FieldValue.serverTimestamp(),
            "isActive": true
        ])
    }

    // Consultar anuncios de una propiedad
    func fetchAnnouncements(
        propertyId: String
    ) async throws -> [Announcement] {

        let snapshot = try await db
            .collection("announcements")
            .whereField("propertyId", isEqualTo: propertyId)
            .getDocuments()

        return snapshot.documents.compactMap { document in
            let data = document.data()

            guard
                let propertyId = data["propertyId"] as? String,
                let title = data["title"] as? String,
                let message = data["message"] as? String
            else {
                return nil
            }

            let timestamp = data["createdAt"] as? Timestamp

            return Announcement(
                id: document.documentID,
                propertyId: propertyId,
                title: title,
                message: message,
                createdAt: timestamp?.dateValue() ?? Date(),
                isActive: data["isActive"] as? Bool ?? true
            )
        }
        .sorted { $0.createdAt > $1.createdAt }
    }

    func fetchActiveAnnouncements(propertyId: String) async throws -> [Announcement] {
        let announcements = try await fetchAnnouncements(propertyId: propertyId)

        return announcements.filter { $0.isActive }
    }
}
