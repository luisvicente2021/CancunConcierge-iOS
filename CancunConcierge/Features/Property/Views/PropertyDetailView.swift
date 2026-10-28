//
//  PropertyDetailView.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import SwiftUI

struct PropertyDetailView: View {

    @State private var property: Property
    private let propertyService = PropertyService()

    @State private var errorMessage: String?
    
    init(property: Property) {
        _property = State(initialValue: property)
    }

    var body: some View {

        Form {

            Section("Property Information") {

                LabeledContent(
                    "Name",
                    value: property.name
                )

                LabeledContent(
                    "Address",
                    value: property.address
                )
            }

            Section("Wi-Fi Information") {

                LabeledContent(
                    "Network",
                    value: property.wifiName
                )

                LabeledContent(
                    "Password",
                    value: property.wifiPassword
                )
            }

            Section("Check-in / Check-out") {

                LabeledContent(
                    "Check-in",
                    value: property.checkIn
                )

                LabeledContent(
                    "Check-out",
                    value: property.checkOut
                )
            }
        }
        .navigationTitle("Property Details")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    PropertyEditView(property: property)
                } label: {
                    Text("Edit")
                }
            }
        }
        
        .onAppear {
            Task {
                await reloadProperty()
            }
        }
    }
    
    private func reloadProperty() async {
        do {
            if let updatedProperty = try await propertyService.getProperty(
                id: property.id
            ) {
                property = updatedProperty
                errorMessage = nil
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        PropertyDetailView(property: Property.example)
    }
}
