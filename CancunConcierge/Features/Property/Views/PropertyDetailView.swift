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


            Section("Announcements") {
                NavigationLink {
                    AnnouncementListView(propertyId: property.id)
                } label: {
                    Label(
                        "View Announcements",
                        systemImage: "megaphone.fill"
                    )
                }
            }


            Section("Guest Access") {
                LabeledContent(
                    "Access Code",
                    value: property.accessCode
                )

                Button {
                    UIPasteboard.general.string = property.accessCode
                } label: {
                    Label("Copy Access Code", systemImage: "doc.on.doc")
                }
                .disabled(property.accessCode.isEmpty)

                Text("Share this code with your guests so they can access the property information.")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
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
