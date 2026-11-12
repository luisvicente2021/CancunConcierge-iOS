
import SwiftUI

struct GuestAccessView: View {

    @State private var accessCode = ""
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var propertyId: String?
    @State private var showDashboard = false

    private let service = GuestAccessService()

    private let primaryColor = Color(
        red: 0.0,
        green: 0.55,
        blue: 0.72
    )

    var body: some View {

        GeometryReader { geometry in

            ScrollView {

                VStack(spacing: 0) {

                    // Imagen principal de Residencial Agua
                    Image("ResidencialAguaBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: 250
                        )
                        .clipped()

                    VStack(spacing: 20) {

                        // Icono de huéspedes
                        Image(systemName: "house.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(primaryColor)
                            .frame(width: 72, height: 72)
                            .background(
                                primaryColor.opacity(0.10),
                                in: Circle()
                            )

                        Text("Acceso de Huéspedes")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(
                                Color(red: 0.04, green: 0.14, blue: 0.32)
                            )
                            .multilineTextAlignment(.center)

                        Text("Bienvenido a Residencial Agua")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        Text("Ingresa el código de acceso de tu alojamiento")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)

                        // Campo de código de acceso
                        HStack(spacing: 12) {

                            Image(systemName: "key.fill")
                                .foregroundStyle(primaryColor)

                            TextField(
                                "Código de acceso",
                                text: $accessCode
                            )
                            .textInputAutocapitalization(.characters)
                            .autocorrectionDisabled()
                        }
                        .padding(15)
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )

                        // Botón continuar
                        Button {

                            Task {
                                await validateAccessCode()
                            }

                        } label: {

                            HStack(spacing: 10) {

                                if isLoading {

                                    ProgressView()
                                        .tint(.white)

                                } else {

                                    Image(systemName: "arrow.right.circle.fill")

                                    Text("Continuar")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .foregroundStyle(.white)
                            .background(
                                LinearGradient(
                                    colors: [
                                        primaryColor,
                                        .cyan
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                        }
                        .disabled(
                            isLoading ||
                            accessCode.trimmingCharacters(
                                in: .whitespacesAndNewlines
                            ).isEmpty
                        )

                        // Mensajes de error
                        if let errorMessage {

                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }

                        // Cerrar sesión de administrador si está activa
                        if errorMessage?.contains("administrator session") == true {

                            Button("Cerrar sesión actual") {

                                do {

                                    try service.signOutCurrentUser()

                                    errorMessage = nil
                                    propertyId = nil

                                } catch {

                                    errorMessage = error.localizedDescription
                                }
                            }
                            .buttonStyle(.bordered)
                            .tint(.red)
                        }

                        // Confirmación de propiedad
                        if let propertyId {

                            Label(
                                "Alojamiento conectado",
                                systemImage: "checkmark.circle.fill"
                            )
                            .foregroundStyle(.green)
                            .font(.subheadline)

                            Text(propertyId)
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                        }

                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationTitle("Acceso de Huéspedes")
        .navigationDestination(isPresented: $showDashboard) {

            if let propertyId {

                GuestDashboardView(propertyId: propertyId)
            }
        }
    }

    @MainActor
    private func validateAccessCode() async {

        isLoading = true
        errorMessage = nil
        propertyId = nil

        defer {
            isLoading = false
        }

        do {

            try await service.signInGuest()

            propertyId = try await service.redeemAccessCode(
                accessCode
            )

            showDashboard = true

        } catch {

            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        GuestAccessView()
    }
}
