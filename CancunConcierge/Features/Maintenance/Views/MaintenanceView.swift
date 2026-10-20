//
//  MaintenanceView.swift
//  CancunConcierge
//
//  Created by usuario on 14/10/26.
//

import SwiftUI

struct MaintenanceView: View {

    @StateObject private var viewModel = MaintenanceViewModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                
                Text("Maintenance Request")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Need assistance with your accommodation?")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                
                VStack(alignment: .leading, spacing: 8) {
                    
                    Text("Issue title")
                        .font(.headline)
                    
                    TextField(
                        "e.g. Air conditioning not working",
                        text: $viewModel.title
                    )
                    .textFieldStyle(.roundedBorder)
                    
                    Text("Description")
                        .font(.headline)
                    
                    TextEditor(text: $viewModel.requestDescription)
                        .frame(height: 120)
                        .padding(4)
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3))
                        }
                }
                
                Button {
                    Task {
                        try await viewModel.submitRequest()
                    }
                 
                } label: {
                    Text("Submit Request")
                        .frame(maxWidth: .infinity)
                        .padding()
                }
                .buttonStyle(.borderedProminent)
                .disabled(viewModel.isLoading || !viewModel.isFormValid)
                
                
                if viewModel.isLoading {
                    ProgressView("Submitting request...")
                }
                
                if !viewModel.message.isEmpty {
                    Text(viewModel.message)
                        .font(.subheadline)
                        .foregroundStyle(.green)
                }
                
            }
            .padding()
        }
        .navigationTitle("Maintenance")
    }
}

#Preview {
    NavigationStack {
        MaintenanceView()
    }
}
