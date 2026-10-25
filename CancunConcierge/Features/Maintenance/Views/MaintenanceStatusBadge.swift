//
//  MaintenanceStatusBadge.swift
//  CancunConcierge
//
//  Created by luisr on 25/10/26.
//

import SwiftUI

struct MaintenanceStatusBadge: View {
    
    let status: MaintenaceStatus
    
    var body: some View {
        Text(status.displayName)
            .foregroundStyle(status.color)
                       .padding(.horizontal, 12)
                       .padding(.vertical, 6)
                       .background(status.color.opacity(0.15))
                       .clipShape(Capsule())
    }
}

#Preview {

    MaintenanceStatusBadge(status: .inProgress)
}
