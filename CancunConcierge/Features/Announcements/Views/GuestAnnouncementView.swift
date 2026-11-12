//
//  Announcement.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import SwiftUI

@MainActor
struct GuestAnnouncementView: View {

    let propertyId: String

    @State private var announcements: [Announcement] = []
    @State private var isLoading = false
    @State private var errorMessage: String?

    private let service = AnnouncementService()

    var body: some View {
        List {
            if isLoading {
                ProgressView("Loading announcements...")

            } else if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)

            } else if announcements.isEmpty {
                ContentUnavailableView(
                    "No announcements",
                    systemImage: "megaphone",
                    description: Text("There are no active announcements.")
                )

            } else {
                ForEach(announcements) { announcement in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(announcement.title)
                            .font(.headline)

                        Text(announcement.message)
                            .font(.subheadline)

                        Text(announcement.createdAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Announcements")
        .task {
            await loadAnnouncements()
        }
    }

    private func loadAnnouncements() async {
        isLoading = true
        errorMessage = nil

        defer {
            isLoading = false
        }

        do {
            announcements = try await service.fetchActiveAnnouncements(
                propertyId: propertyId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
