//
//  PropertyListView.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import SwiftUI

struct PropertyListView: View {

    @StateObject private var viewModel = PropertyListViewModel()

    var body: some View {

        Group {
            if viewModel.isLoading {
                ProgressView("Loading properties...")

            } else if let errorMessage = viewModel.errorMessage {
                ContentUnavailableView(
                    "Unable to load properties",
                    systemImage: "exclamationmark.triangle",
                    description: Text(errorMessage)
                )

            } else if viewModel.properties.isEmpty {
                ContentUnavailableView(
                    "No Properties",
                    systemImage: "house",
                    description: Text("You don't have any properties yet.")
                )

            } else {
                List(viewModel.properties) { property in

                    VStack(alignment: .leading, spacing: 8) {

                        Text(property.name)
                            .font(.headline)

                        Label(
                            property.address,
                            systemImage: "mappin.and.ellipse"
                        )
                        .font(.subheadline)
                        .foregroundStyle(.secondary)

                        Text("Check-in: \(property.checkIn)")
                            .font(.caption)

                        Text("Check-out: \(property.checkOut)")
                            .font(.caption)
                    }
                    .padding(.vertical, 6)
                }
            }
        }
        .navigationTitle("My Properties")
        .task {
            await viewModel.loadProperties()
        }
    }
}

#Preview {
    NavigationStack {
        PropertyListView()
    }
}
