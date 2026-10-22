//
//  MaintenanceListViewModel.swift
//  CancunConcierge
//
//  Created by luisr on 21/10/26.
//

import Foundation
import Combine


class MaintenanceListViewModel: ObservableObject {
    
    @Published var requests: [MaintenanceRecord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
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
}
