//
//  MaintenanceService.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

final class MaintenanceService {
    
    private let db = Firestore.firestore()
    
    func submitRequest(_ request: MaintenanceRequest) async throws {
        
        guard let user = Auth.auth().currentUser else {
            throw MaintenanceError.notAuthenticated
        }
        
        guard request.guestId == user.uid else {
            throw MaintenanceError.invalidUser
        }
        
        let data: [String: Any] = [
            "title": request.title,
            "description": request.description,
            "guestId": user.uid,
            "status": "pending",
            "createdAt": FieldValue.serverTimestamp()
        ]
        
        _ = try await db.collection("maintenance_requests")
            .addDocument(data: data)
    }
}
