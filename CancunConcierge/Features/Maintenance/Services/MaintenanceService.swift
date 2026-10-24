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
    
    func fetchRequests() async throws -> [MaintenanceRecord] {
        
        guard let uid = Auth.auth().currentUser?.uid else {
            throw MaintenanceError.notAuthenticated
        }
        
        print("Current Firebase UID: \(uid)")
        let snapshot = try await db.collection("maintenance_requests")
            .whereField("guestId", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .getDocuments()
        
        print("Documents found: \(snapshot.documents.count)")
        
        let requests = snapshot.documents.compactMap { document -> MaintenanceRecord? in
            
            let data = document.data()
            guard
                let title = data ["title"] as? String,
                let description = data ["description"] as? String,
                let guestId = data["guestId"] as? String,
                let statusString = data["status"] as? String,
                let status = MaintenaceStatus(rawValue: statusString),
                let timestamp = data["createdAt"] as? Timestamp
                    
            else {
                return nil
            }
            return MaintenanceRecord(id: document.documentID, title: title, description: description, guestId: guestId, status: status, createdAt: timestamp.dateValue())
                    
        }
        
        return requests
    }
    
    
    func listenToRequest(onchange: @escaping([MaintenanceRecord]) -> Void) -> ListenerRegistration? {
        guard let uid  = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        let listener = db.collection("maintenance_requests")
            .whereField("guestId", isEqualTo: uid)
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { snapshot, error in
                
                if let error = error {
                    print("Error escuchando solicitudes:", error.localizedDescription)
                }
                
                guard let snapshot = snapshot else {
                    return
                }
                
                print("Solicitudes detectadas:", snapshot.documents.count)
                
                let requests = snapshot.documents.compactMap {document -> MaintenanceRecord? in
                
                    let data = document.data()
                    
                        guard
                            let title = data ["title"] as? String,
                            let description = data ["description"] as? String,
                            let guestId = data["guestId"] as? String,
                            let statusString = data["status"] as? String,
                            let status = MaintenaceStatus(rawValue: statusString),
                            let timestamp = data["createdAt"] as? Timestamp
                                
                    else {
                            return nil
                        }
                    return MaintenanceRecord(id: document.documentID, title: title, description: description, guestId: guestId, status: status, createdAt: timestamp.dateValue())
                    
                }
            }
        return listener
        
    }
}
