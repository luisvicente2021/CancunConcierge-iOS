//
//  PropertyCreateViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import Foundation
import FirebaseAuth

@MainActor
final class PropertyCreateViewModel: ObservableObject {

    @Published var name = ""
    @Published var address = ""
    @Published var wifiName = ""
    @Published var wifiPassword = ""
    @Published var checkIn = ""
    @Published var checkOut = ""

    @Published var isSaving = false
    @Published var errorMessage: String?
    @Published var isSaved = false

    private let propertyService = PropertyService()

    func createProperty() async {

        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
              !address.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Property name and address are required."
            return
        }

        guard let ownerId = Auth.auth().currentUser?.uid else {
            errorMessage = "User is not authenticated."
            return
        }

        print("🔐 Current user UID:", ownerId)
        print("🔐 Is anonymous:", Auth.auth().currentUser?.isAnonymous ?? true)

        isSaving = true
        errorMessage = nil

        defer {
            isSaving = false
        }
        
        let accessCode: String

        do {
            accessCode = try AccessCodeGenerator.generate()
        } catch {
            errorMessage = "Unable to generate an access code. Please try again."
            return
        }

        let property = Property(
            id: "",
            ownerId: ownerId, 
            accessCode: accessCode,
            name: name,
            address: address,
            wifiName: wifiName,
            wifiPassword: wifiPassword,
            checkIn: checkIn,
            checkOut: checkOut
        )

        do {
            try await propertyService.createProperty(property)
            isSaved = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
