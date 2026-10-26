//
//  MaintenanceDetailView.swift
//  CancunConcierge
//
//  Created by luisr on 25/10/26.
//

import SwiftUI

struct MaintenanceDetailView: View {

    @StateObject private var viewModel: MaintenanceDetailViewModel
    
    init(request: MaintenanceRecord) {
        _viewModel = StateObject(
            wrappedValue: MaintenanceDetailViewModel(request: request)
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            Text(viewModel.request.title)
                .font(.title)
                .bold()

            VStack(alignment: .leading, spacing: 8) {
                Text("Description")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                Text(viewModel.request.description)
                    .font(.body)
            }

            VStack(alignment: .leading, spacing: 8) {

                Text("Status")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Status")
                        .font(.headline)
                        .foregroundStyle(.secondary)

                    MaintenanceStatusBadge(status: viewModel.request.status)
                }
            }
            
            VStack(alignment: .leading, spacing: 8) {

                Text("Created on")
                    .font(.headline)
                    .foregroundStyle(.secondary)

                HStack(spacing: 8) {
                    Image(systemName: "calendar")
                        .foregroundStyle(.secondary)

                    Text(viewModel.request.createdAt, style: .date)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer()
        }
        .padding()
        .navigationTitle("Request Details")
        .navigationBarTitleDisplayMode(.inline)
        
        .onAppear {
            viewModel.startListening()
        }
        .onDisappear {
            viewModel.stopListening()
        }
    }
}
#Preview {
    MaintenanceDetailView(request: MaintenanceRecord(id: "", title: "", description: "", guestId: "", status: .pending, createdAt: Date()))
}
