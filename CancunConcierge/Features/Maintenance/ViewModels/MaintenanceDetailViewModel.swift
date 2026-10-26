//
//  MaintenanceDetailViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 26/10/26.
//

import Foundation
import FirebaseFirestore

@MainActor
final class MaintenanceDetailViewModel: ObservableObject {
    
    @Published var request: MaintenanceRecord
    private let service = MaintenanceService()
    private var listener: ListenerRegistration?
    
    init(request: MaintenanceRecord) {
        self.request = request
    }
    
    func startListening() {

        listener?.remove()

        listener = service.listenToRequest(id: request.id) { [weak self] updatedRequest in

            guard let self = self,
                  let updatedRequest = updatedRequest else {
                return
            }

            Task { @MainActor in
                self.request = updatedRequest
            }
        }
    }
    
    func stopListening() {
        listener?.remove()
        listener = nil
    }
}
