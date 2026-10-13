//
//  WelcomeView.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import SwiftUI

struct WelcomeView: View {

    var body: some View {
        VStack(spacing: 30) {

            Image(systemName: "sun.max.fill")
                .font(.system(size: 60))
                .foregroundStyle(.blue)

            Text("Welcome to Cancún")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Your personal vacation concierge")
                .font(.subheadline)
                .foregroundStyle(.secondary)

        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
