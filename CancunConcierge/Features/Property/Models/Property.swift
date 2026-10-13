//
//  Property.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import Foundation

struct Property: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let wifiName: String
    let wifiPassword: String
    let checkIn: String
    let checkOut: String
}


extension Property {

    static let example = Property(
        id: UUID(),
        name: "Cancún Ocean View",
        address: "Zona Hotelera, Cancún",
        wifiName: "OceanView_Guest",
        wifiPassword: "Demo12345",
        checkIn: "3:00 PM",
        checkOut: "11:00 AM"
    )
}
