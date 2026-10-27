//
//  AdminLoginView.swift
//  CancunConcierge
//
//  Created by usuario on 26/10/26.
//

import SwiftUI

struct AdminLoginView: View {

    @StateObject private var viewModel = AdminLoginViewModel()

    var body: some View {
        VStack(spacing: 20) {

            Text("Owner Login")
                .font(.largeTitle)
                .bold()

            TextField("Email", text: $viewModel.email)
                .textInputAutocapitalization(.never)
                .keyboardType(.emailAddress)
                .autocorrectionDisabled()
                .textFieldStyle(.roundedBorder)

            SecureField("Password", text: $viewModel.password)
                .textFieldStyle(.roundedBorder)

            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }

            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                if viewModel.isLoading {
                    ProgressView()
                } else {
                    Text("Sign In")
                }
            }
            .buttonStyle(.borderedProminent)
            .disabled(viewModel.isLoading)

        }
        .padding()
               .navigationDestination(isPresented: $viewModel.isAuthenticated) {
                   AdminDashboardView()
               }
    }
}

#Preview {
    AdminLoginView()
}
