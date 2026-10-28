//
//  PropertyEditViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import Foundation

@MainActor
final class PropertyEditViewModel: ObservableObject {

    @Published var name: String
    @Published var address: String
    @Published var wifiName: String
    @Published var wifiPassword: String
    @Published var checkIn: String
    @Published var checkOut: String

    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var isSaved = false

    private let property: Property
    private let propertyService = PropertyService()

    init(property: Property) {
        self.property = property

        self.name = property.name
        self.address = property.address
        self.wifiName = property.wifiName
        self.wifiPassword = property.wifiPassword
        self.checkIn = property.checkIn
        self.checkOut = property.checkOut
    }

    func saveChanges() async {

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Name and address are required."
            return
        }

        isSaving = true
        errorMessage = nil

        defer {
            isSaving = false
        }

        let updatedProperty = Property(
            id: property.id,
            ownerId: property.ownerId,
            name: name,
            address: address,
            wifiName: wifiName,
            wifiPassword: wifiPassword,
            checkIn: checkIn,
            checkOut: checkOut
        )

        do {
            try await propertyService.updateProperty(updatedProperty)
            isSaved = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
