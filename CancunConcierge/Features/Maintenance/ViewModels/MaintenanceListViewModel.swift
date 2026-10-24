//
//  MaintenanceListViewModel.swift
//  CancunConcierge
//
//  Created by luisr on 21/10/26.
//

import Foundation
import Combine
import FirebaseFirestore


class MaintenanceListViewModel: ObservableObject {
    
    @Published var requests: [MaintenanceRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var listener: ListenerRegistration?
    private let service = MaintenanceService()
    
    func loadRequests() async {
        isLoading = true
        errorMessage = nil
        
        defer {
            isLoading = false
        }
        
        do {
            requests = try await service.fetchRequests()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    func startListening() {
        
        listener?.remove()
        
        listener = service.listenToRequest(onchange: { [weak self] requests in
            
            guard let self = self  else {
                return
            }
            
            Task {
                 @MainActor in
                self.requests = requests
                print("solicitudes guardadas en el viewmodel \(self.requests.count)")
            }
        })
    }
    
    func stopListening() {
        
        listener?.remove()
        listener = nil
    }
}
