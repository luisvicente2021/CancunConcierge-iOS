//
//  MaintenanceViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation
import Combine

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
    
    func submitRequest() {
        
        guard isFormValid, !isLoading else {
            return
        }
        isLoading = true
        
        let request = MaintenanceRequest(
            id: UUID(),
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            description: requestDescription.trimmingCharacters(in: .whitespacesAndNewlines),
            status: .pending,
            createdAt: Date())
        
        service.submitRequest(request) { [weak self] success in
            guard let self = self else { return }
            
            self.isLoading = false
            
            if success {
                self.message = "Request submitted successfully"
            } else {
                self.message = "Something went wrong"
            }
            
        }
    }
    
}
