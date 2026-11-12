//
//  Announcement.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import Foundation

struct Announcement: Identifiable, Codable {
    var id: String
    var propertyId: String
    var title: String
    var message: String
    var createdAt: Date
    var isActive: Bool
}
