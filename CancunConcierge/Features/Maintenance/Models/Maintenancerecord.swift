//
//  Maintenancerecord.swift
//  CancunConcierge
//
//  Created by luisr on 21/10/26.
//

import Foundation

struct MaintenanceRecord: Identifiable {
    
    let id: String
    let title: String
    let description: String
    let guestId: String
    let status: MaintenaceStatus
    let createdAt: Date
}
