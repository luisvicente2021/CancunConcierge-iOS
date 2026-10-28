//
//  PropertyEditView.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import SwiftUI

struct PropertyEditView: View {

    @StateObject private var viewModel: PropertyEditViewModel
    @Environment(\.dismiss) private var dismiss

    init(property: Property) {
        _viewModel = StateObject(
            wrappedValue: PropertyEditViewModel(property: property)
        )
    }

    var body: some View {

        Form {

            Section("Property Information") {

                TextField("Property Name", text: $viewModel.name)

                TextField("Address", text: $viewModel.address)
            }

            Section("Wi-Fi Information") {

                TextField("Network Name", text: $viewModel.wifiName)

                SecureField(
                    "Wi-Fi Password",
                    text: $viewModel.wifiPassword
                )
            }

            Section("Check-in / Check-out") {

                TextField("Check-in", text: $viewModel.checkIn)

                TextField("Check-out", text: $viewModel.checkOut)
            }

            if let errorMessage = viewModel.errorMessage {

                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                }
            }

            Section {

                Button {
                    Task {
                        await viewModel.saveChanges()
                    }
                } label: {

                    HStack {
                        Spacer()

                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Save Changes")
                        }

                        Spacer()
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .navigationTitle("Edit Property")
        .navigationBarTitleDisplayMode(.inline)
        .onChange(of: viewModel.isSaved) { _, isSaved in
            if isSaved {
                dismiss()
            }
        }
    }
}

#Preview {
    NavigationStack {
        PropertyEditView(property: Property.example)
    }
}
