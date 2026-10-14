//
//  MaintenanceRequest.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation

struct MaintenanceRequest: Identifiable, Codable {
    
    let id: UUID
    let title: String
    let description: String
    let status: MaintenaceStatus
    let createdAt: Date
    
}

extension MaintenanceRequest {
    
    static let exmaple = MaintenanceRequest(id: UUID(), title: "Air Condition", description: "isn't working in the bedroom", status: .pending, createdAt: Date())
}
