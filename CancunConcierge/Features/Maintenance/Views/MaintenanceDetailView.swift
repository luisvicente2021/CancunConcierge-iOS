//
//  MaintenanceDetailView.swift
//  CancunConcierge
//
//  Created by luisr on 25/10/26.
//

import SwiftUI

struct MaintenanceDetailView: View {

    let request: MaintenanceRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(request.title)
                .font(.title)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(request.description)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 8) {

                Text("Status")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                MaintenanceStatusBadge(status: request.status)
            }
            
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .foregroundStyle(.secondary)

                Text(request.createdAt, style: .date)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    MaintenanceDetailView(request: MaintenanceRecord(id: "", title: "", description: "", guestId: "", status: .pending, createdAt: Date()))
}
