//
//  AnnouncementCreateView.swift
//  CancunConcierge
//
//  Created by usuario on 11/11/26.
//

import SwiftUI

@MainActor
struct AnnouncementCreateView: View {

    let propertyId: String

    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var message = ""
    @State private var isSaving = false
    @State private var errorMessage: String?

    private let service = AnnouncementService()

    var body: some View {
        Form {
            Section("Announcement Details") {
                TextField("Title", text: $title)

                TextEditor(text: $message)
                    .frame(minHeight: 120)
            }

            if let errorMessage {
                Text(errorMessage)
                    .foregroundStyle(.red)
            }

            Section {
                Button {
                    Task {
                        await saveAnnouncement()
                    }
                } label: {
                    if isSaving {
                        ProgressView()
                    } else {
                        Text("Publish Announcement")
                    }
                }
                .disabled(
                    isSaving ||
                    title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ||
                    message.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                )
            }
        }
        .navigationTitle("New Announcement")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func saveAnnouncement() async {
        isSaving = true
        errorMessage = nil
        defer { isSaving = false }

        do {
            try await service.createAnnouncement(
                propertyId: propertyId,
                title: title.trimmingCharacters(in: .whitespacesAndNewlines),
                message: message.trimmingCharacters(in: .whitespacesAndNewlines)
            )

            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
