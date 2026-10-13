//
//  PropertyView.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import SwiftUI

struct PropertyView: View {
    
    let property: Property

    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text(property.name)
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(property.address)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            VStack(alignment: .leading, spacing: 12) {

                InfoCardView(
                    title: "Wi-Fi Information",
                    icon: "wifi"
                ) {
                    Text("Network: \(property.wifiName)")
                    Text("Password: \(property.wifiPassword)")
                }

            }
            
            VStack(alignment: .leading, spacing: 12) {
                InfoCardView(
                    title: "Check-in / Check-out",
                    icon: "clock"
                ) {
                    HStack {
                        Text("Check-in")
                        Spacer()
                        Text(property.checkIn)
                    }

                    HStack {
                        Text("Check-out")
                        Spacer()
                        Text(property.checkOut)
                    }
                }
                
            }

            Text("Your home away from home")
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Accommodation")
    }
}

#Preview {
    NavigationStack {
        PropertyView(property: Property.example)
    }
}
