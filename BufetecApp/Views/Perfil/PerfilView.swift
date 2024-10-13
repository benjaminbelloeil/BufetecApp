import SwiftUI

struct PerfilView: View {
    var body: some View {
        ScrollView {
            VStack {
                VStack(spacing: 16) {
                    // Top bar
                    ZStack {
                        Color(.systemBackground)
                        Text("Mi perfil")
                            .font(.headline)
                            .fontWeight(.semibold)
                    }
                    .frame(height: 44)
                    .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 3)

                    // Profile image and name
                    VStack {
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())

                            Text("C")
                                .font(.system(size: 40, weight: .bold))
                                .foregroundColor(.white)
                        }
                        .overlay(Circle().stroke(Color.white, lineWidth: 3))
                        .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                        .padding(.top, 8)

                        Text("Lic. Carolina Leyva Acosta")
                            .font(.title3)
                            .fontWeight(.semibold)
                            .padding(.top, 8)

                        Text("Abogado")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .padding(.top, 2)
                    }
                    .padding(.bottom, 8)
                    .background(
                        Color(.systemBackground)
                    )

                    // Information cards
                    VStack(spacing: 20) {
                        infoCard(title: "Información Personal", content: [
                            ("Casos", "1"),
                            ("Especialidad", "Asuntos de familia y matrimonio"),
                            ("Teléfono", "XXXXXXXXX"),
                            ("Correo", "......@gmail.com")
                        ])
                    }
                    .padding(.horizontal)

                    // Action buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            // Acción para cerrar sesión
                        }) {
                            Text("Cerrar sesión")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.red)
                                .cornerRadius(12)
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 16)
                    .padding(.bottom, 16)
                    Spacer()
                }
            }
        }
        .background(Color(.systemBackground))
    }

    private func infoCard(title: String, content: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.bottom, 5)

            ForEach(content, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.1)
                        .fontWeight(.medium)
                }
                .font(.subheadline)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
    }
}
