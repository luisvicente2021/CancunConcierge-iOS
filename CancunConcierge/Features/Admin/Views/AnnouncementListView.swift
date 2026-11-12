//
//  AnnouncementListView.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import SwiftUI

struct AnnouncementListView: View {

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
                    description: Text("No announcements have been published yet.")
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

                        if announcement.isActive {
                            Button("Deactivate Announcement", role: .destructive) {
                                Task {
                                    await deactivateAnnouncement(announcement)
                                }
                            }
                            .buttonStyle(.borderless)
                        } else {
                            Label("Inactive", systemImage: "checkmark.circle")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }

        .navigationTitle("Announcements")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    AnnouncementCreateView(propertyId: propertyId)
                } label: {
                    Image(systemName: "plus")
                }
            }
        }
        .onAppear {
            Task {
                await loadAnnouncements()
            }
        }
    }

    private func loadAnnouncements() async {
        isLoading = true
        errorMessage = nil
        defer { isLoading = false }

        do {
            announcements = try await service.fetchAnnouncements(
                propertyId: propertyId
            )
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    @MainActor
    private func deactivateAnnouncement(_ announcement: Announcement) async {
        do {
            try await service.deactivateAnnouncement(id: announcement.id)

            await loadAnnouncements()

        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
