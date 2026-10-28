//
//  PropertyListViewModel.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import Foundation

@MainActor
final class PropertyListViewModel: ObservableObject {

    @Published var properties: [Property] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    private let propertyService = PropertyService()

    func loadProperties() async {

        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            properties = try await propertyService.getProperties()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
