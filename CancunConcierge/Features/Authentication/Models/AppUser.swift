//
//  AppUser.swift
//  CancunConcierge
//
//  Created by usuario on 26/10/26.
//

import Foundation

struct AppUser: Identifiable, Codable {
    
    let id: String
    let role: UserRole
    let propertyId: String?
}
