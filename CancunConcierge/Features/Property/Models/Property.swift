//
//  Property.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import Foundation

struct Property: Identifiable {

    let id: String
    let ownerId: String
    
    let accessCode: String

    let name: String
    let address: String

    let wifiName: String
    let wifiPassword: String

    let checkIn: String
    let checkOut: String
}

extension Property {

    static let example = Property(
        id: "demo-property-001",
        ownerId: "demo-owner-001",
        accessCode: "CN-DEMO01",
        name: "Cancún Ocean View",
        address: "Zona Hotelera, Cancún",
        wifiName: "OceanView_Guest",
        wifiPassword: "Demo12345",
        checkIn: "3:00 PM",
        checkOut: "11:00 AM"
    )
}
