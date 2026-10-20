//
//  MaintenanceError.swift
//  CancunConcierge
//
//  Created by luisr on 19/10/26.
//
import Foundation

enum MaintenanceError: LocalizedError {
    
    case notAuthenticated
    case invalidUser
    
    var errorDescription: String? {
        
        switch self {
        
        case .notAuthenticated:
            return "Use is not authenticated"
        case .invalidUser:
            return "The request does not belong to the current user"
        }
    }
}
