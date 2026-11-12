
import SwiftUI

struct AdminLoginView: View {

    @StateObject private var viewModel = AdminLoginViewModel()

    private let primaryBlue = Color(
        red: 0.03,
        green: 0.34,
        blue: 0.73
    )

    var body: some View {

        GeometryReader { geometry in

            ScrollView {

                VStack(spacing: 0) {

                    // Encabezado de Residencial Agua
                    Image("ResidencialAguaBanner")
                        .resizable()
                        .scaledToFill()
                        .frame(
                            width: geometry.size.width,
                            height: 250
                        )
                        .clipped()

                    // Formulario
                    VStack(spacing: 20) {

                        Image(systemName: "building.2.fill")
                            .font(.system(size: 35))
                            .foregroundStyle(primaryBlue)
                            .frame(width: 72, height: 72)
                            .background(
                                Color.blue.opacity(0.09),
                                in: Circle()
                            )

                        Text("Acceso de Propietario")
                            .font(.system(size: 26, weight: .bold))
                            .foregroundStyle(
                                Color(red: 0.04, green: 0.14, blue: 0.32)
                            )
                            .multilineTextAlignment(.center)

                        Text("Administre su propiedad")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)

                        // Correo electrónico
                        HStack(spacing: 12) {

                            Image(systemName: "envelope")
                                .foregroundStyle(primaryBlue)

                            TextField(
                                "Correo electrónico",
                                text: $viewModel.email
                            )
                            .textInputAutocapitalization(.never)
                            .keyboardType(.emailAddress)
                            .autocorrectionDisabled()
                        }
                        .padding(15)
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )

                        // Contraseña
                        HStack(spacing: 12) {

                            Image(systemName: "lock")
                                .foregroundStyle(primaryBlue)

                            SecureField(
                                "Contraseña",
                                text: $viewModel.password
                            )
                        }
                        .padding(15)
                        .background(
                            Color(.secondarySystemBackground)
                        )
                        .clipShape(
                            RoundedRectangle(cornerRadius: 12)
                        )

                        // Mensaje de error
                        if let errorMessage = viewModel.errorMessage {

                            Text(errorMessage)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .multilineTextAlignment(.center)
                        }

                        // Iniciar sesión
                        Button {

                            Task {
                                await viewModel.signIn()
                            }

                        } label: {

                            HStack(spacing: 10) {

                                if viewModel.isLoading {
                                    ProgressView()
                                        .tint(.white)
                                } else {
                                    Image(systemName: "arrow.right.circle.fill")

                                    Text("Iniciar Sesión")
                                        .fontWeight(.semibold)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 17)
                            .foregroundStyle(.white)
                            .background(
                                LinearGradient(
                                    colors: [
                                        primaryBlue,
                                        Color.blue
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .clipShape(
                                RoundedRectangle(cornerRadius: 14)
                            )
                        }
                        .disabled(viewModel.isLoading)

                    }
                    .padding(24)
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color(.systemBackground))
        }
        .navigationDestination(
            isPresented: $viewModel.isAuthenticated
        ) {
            AdminDashboardView()
        }
    }
}

#Preview {
    NavigationStack {
        AdminLoginView()
    }
}
