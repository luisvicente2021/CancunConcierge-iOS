//
//  MaintenanceViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation
import Combine
import FirebaseAuth

final class MaintenanceViewModel: ObservableObject {
    
    @Published var isLoading = false
    @Published var message = ""
    @Published var title = ""
    @Published var requestDescription = ""
    
    var isFormValid: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !requestDescription.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private let service = MaintenanceService()
    
    @MainActor
    func submitRequest() {
        
        guard isFormValid, !isLoading else {
            return
        }
        isLoading = true
        
        Task {
            
            do {
                guard let uid = Auth.auth().currentUser?.uid else {
                    throw MaintenanceError.notAuthenticated
                }
                
                let request = MaintenanceRequest(
                    title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                    description: requestDescription.trimmingCharacters(in: .whitespacesAndNewlines),
                    guestId: uid)
                
                
                try await service.submitRequest(request)
                
                message = "Maintenance request submitted successfully"
                title = ""
                requestDescription = ""
            }catch {
                message = "Error: \(error.localizedDescription)"
            }
            
            isLoading = false
        }
    }
}
