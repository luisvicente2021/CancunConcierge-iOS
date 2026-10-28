//
//  PropertyCreateView.swift
//  CancunConcierge
//
//  Created by usuario on 28/10/26.
//

import SwiftUI

struct PropertyCreateView: View {

    @StateObject private var viewModel = PropertyCreateViewModel()
    @Environment(\.dismiss) private var dismiss

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
                        await viewModel.createProperty()
                    }
                } label: {

                    HStack {
                        Spacer()

                        if viewModel.isSaving {
                            ProgressView()
                        } else {
                            Text("Save Property")
                        }

                        Spacer()
                    }
                }
                .disabled(viewModel.isSaving)
            }
        }
        .navigationTitle("Add Property")
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
        PropertyCreateView()
    }
}
