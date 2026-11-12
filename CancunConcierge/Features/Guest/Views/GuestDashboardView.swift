//
//  GuestDashboardView.swift
//  CancunConcierge
//
//  Created by usuario on 12/11/26.
//


import SwiftUI
import FirebaseAuth

struct GuestDashboardView: View {

    let propertyId: String
    @Environment(\.dismiss) private var dismiss
    @State private var showSignOutError = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {

                Image(systemName: "house.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)

                Text("Welcome to Cancun Concierge")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text("Your accommodation services")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                VStack(spacing: 16) {

                    dashboardCard(
                        title: "My Accommodation",
                        icon: "house"
                    )

                    NavigationLink {
                        GuestAnnouncementView(
                            propertyId: propertyId
                        )
                    } label: {
                        dashboardCard(
                            title: "Announcements",
                            icon: "megaphone.fill"
                        )
                    }
                    .buttonStyle(.plain)

                    dashboardCard(
                        title: "Maintenance Requests",
                        icon: "wrench.fill"
                    )

                    dashboardCard(
                        title: "Messages",
                        icon: "message.fill"
                    )
                }
            }
            .padding()
        }

        .navigationTitle("Guest Dashboard")
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    do {
                        try Auth.auth().signOut()
                        dismiss()
                    } catch {
                        showSignOutError = true
                    }
                } label: {
                    Label("Sign Out", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
        }
        .alert("Sign Out Error", isPresented: $showSignOutError) {
            Button("OK", role: .cancel) { }
        } message: {
            Text("Unable to sign out. Please try again.")
        }

    }

    private func dashboardCard(
        title: LocalizedStringKey,
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
        GuestDashboardView(propertyId: "example-property")
    }
}
