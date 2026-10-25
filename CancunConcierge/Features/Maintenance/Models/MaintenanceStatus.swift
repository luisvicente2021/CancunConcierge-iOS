//
//  MaintenanceStatus.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import Foundation
import SwiftUI

enum MaintenaceStatus: String, Codable {
    
    case pending
    case inProgress = "in_progress"
    case resolved
    
    
    var displayName: String {
        switch self {
        case .pending:
            return "Pending"
        case .inProgress:
            return "In Progress"
        case .resolved:
            return "Resolved"
        }
    }
    
    var color: Color {
        switch self {
        case .pending:
            return .orange
        
        case .inProgress:
            return .yellow
            
        case .resolved:
            return .green
        }
    }
}



