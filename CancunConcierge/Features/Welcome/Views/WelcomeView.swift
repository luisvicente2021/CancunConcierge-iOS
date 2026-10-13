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
            
            NavigationLink {
                PropertyView(property: Property.example)
            } label: {
                Text("Get Started")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }

        }
        .padding()
    }
}

#Preview {
    WelcomeView()
}
