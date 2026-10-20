//
//  MaintenanceRequest.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation

struct MaintenanceRequest: Encodable {
    
    let title: String
    let description: String
    let guestId: String
}

extension MaintenanceRequest {
    
    static let exmaple = MaintenanceRequest(title: "Air Condition", description: "isn't working in the bedroom",  guestId: "Luisao")
}
