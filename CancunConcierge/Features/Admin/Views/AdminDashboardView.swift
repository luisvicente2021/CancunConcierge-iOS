//
//  AdminDashboardView.swift
//  CancunConcierge
//
//  Created by usuario on 27/10/26.
//

import SwiftUI

struct AdminDashboardView: View {
    
    @Environment(\.dismiss) private var dismiss

    private let authService = AuthService()

    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 24) {

            Image(systemName: "building.2.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Owner Dashboard")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Manage your vacation properties")
                .font(.subheadline)
                .foregroundStyle(.secondary)

            VStack(spacing: 16) {

                dashboardButton(
                    title: "My Properties",
                    icon: "house.fill"
                )

                dashboardButton(
                    title: "Maintenance Requests",
                    icon: "wrench.fill"
                )

                dashboardButton(
                    title: "Announcements",
                    icon: "megaphone.fill"
                )

                dashboardButton(
                    title: "Invitations",
                    icon: "envelope.fill"
                )
            }
            Button("Sign Out") {
                do {
                    try authService.signOut()
                    dismiss()
                } catch {
                    errorMessage = error.localizedDescription
                }
            }
            .buttonStyle(.bordered)
            .tint(.red)

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
                    .font(.caption)
            }
        }
        .padding()
        .navigationBarBackButtonHidden()
    }

    private func dashboardButton(
        title: String,
        icon: String
    ) -> some View {

        HStack(spacing: 16) {

            Image(systemName: icon)
                .font(.title2)
                .frame(width: 30)

            Text(title)
                .fontWeight(.semibold)

            Spacer()

            Image(systemName: "chevron.right")
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    NavigationStack {
        AdminDashboardView()
    }
}
