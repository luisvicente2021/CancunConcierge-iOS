//
//  MaintenanceStatus.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation

enum MaintenaceStatus: String, Codable {
    
    case pending
    case inProgress = "in_Progress"
    case resolved
}
