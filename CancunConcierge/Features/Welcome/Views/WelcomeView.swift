//
//  WelcomeView.swift
//  CancunConcierge
//
//  Created by usuario on 13/10/26.
//


import SwiftUI

struct WelcomeView: View {

    var body: some View {

        GeometryReader { geometry in

            ScrollView {

                VStack(spacing: 0) {

                    // Imagen principal de la residencial
                    Image("ResidencialAguaBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: geometry.size.height * 0.48,
                            alignment: .top
                        )
                        .clipped()

                    // Sección de bienvenida
                    VStack(spacing: 20) {

                        Text("Bienvenido a Residencial Agua")
                            .font(.system(size: 27, weight: .bold))
                            .foregroundStyle(Color(red: 0.04, green: 0.16, blue: 0.40))
                            .multilineTextAlignment(.center)

                        Text("Tu concierge de alojamiento")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        // Acceso para huéspedes
                        NavigationLink {
                            GuestAccessView()
                        } label: {

                            Label(
                                "Acceso Huésped",
                                systemImage: "house.fill"
                            )
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .cyan],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                        }

                        // Acceso para propietarios
                        NavigationLink {
                            AdminLoginView()
                        } label: {

                            Label(
                                "Acceso Propietario",
                                systemImage: "building.2.fill"
                            )
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 18)
                            .background(
                                LinearGradient(
                                    colors: [.green, .teal],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundStyle(.white)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 16)
                            )
                        }

                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                    .background(.white)

                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    NavigationStack {
        WelcomeView()
    }
}
