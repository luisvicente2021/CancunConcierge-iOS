//
//  GuestAccessView.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import SwiftUI

struct GuestAccessView: View {

    @State private var accessCode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var propertyId: String?

    private let service = GuestAccessService()

    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "house.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Welcome to Cancun Concierge")
                .font(.title2)
                .bold()
                .multilineTextAlignment(.center)

            Text("Enter your accommodation access code")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            TextField("Access Code", text: $accessCode)
                .textInputAutocapitalization(.characters)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            Button {
                Task {
                    await validateAccessCode()
                }
            } label: {
                if isLoading {
                    ProgressView()
                } else {
                    Text("Continue")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(
                isLoading ||
                accessCode.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty
            )
            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            if let propertyId {
                Text("Property connected: \(propertyId)")
                    .foregroundStyle(.green)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Guest Access")
    }

    @MainActor
    private func validateAccessCode() async {
        isLoading = true
        errorMessage = nil
        propertyId = nil

        defer {
            isLoading = false
        }

        do {
            try await service.signInGuest()

            propertyId = try await service.redeemAccessCode(
                accessCode
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
