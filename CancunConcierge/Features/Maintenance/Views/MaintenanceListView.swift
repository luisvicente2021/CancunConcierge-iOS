//
//  MaintenanceListView.swift
//  CancunConcierge
//
//  Created by luisr on 21/10/26.
//

import SwiftUI

struct MaintenanceListView: View {
    
    @StateObject private var viewModel = MaintenanceListViewModel()
    
    var body: some View {
        
        Group {
            
            if viewModel.isLoading {
                ProgressView("Loading requests....")
                
            } else if let error = viewModel.errorMessage {
                ContentUnavailableView("Unable to load requets",systemImage: "exclamationmark.triangle", description: Text(error))
            } else if viewModel.requests.isEmpty {
                ContentUnavailableView("No maintenance requests",systemImage: "tray", description: Text("You haven't submitted any requests yet"))
            } else {
                
                List(viewModel.requests) { request in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(request.title)
                            .font(.headline)
                        
                        Text(request.description)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        
                        MaintenanceStatusBadge(status: request.status)
                        
                        Text(request.createdAt, style: .date)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("My Requests")
        .onAppear{
            viewModel.startListening()
        }
        .onDisappear{
            viewModel.stopListening()
        }
       
        }
    }
