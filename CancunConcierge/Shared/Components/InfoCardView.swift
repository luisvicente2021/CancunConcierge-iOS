//
//  InfoCardView.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//

import SwiftUI

struct InfoCardView<Content: View>: View {

    let title: String
    let icon: String
    let content: Content

    init(
        title: String,
        icon: String,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.icon = icon
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            Label(title, systemImage: icon)
                .font(.headline)

            content

        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}
