import SwiftUI

struct PerfilView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Top bar
                HStack {
                    Spacer()
                    Text("Mi perfil")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                // Profile image and name
                VStack {
                    Image("profile_placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 120, height: 120)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                        .padding(.top, 20)

                    Text("Lic. Carolina Leyva Acosta")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.top, 8)

                    Text("Abogado")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.bottom, 20)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.3), Color.white]), startPoint: .top, endPoint: .bottom)
                )

                // Information cards
                VStack(spacing: 20) {
                    infoCard(title: "Información Personal", content: [
                        ("Casos", "1"),
                        ("Especialidad", "Asuntos de familia y matrimonio"),
                        ("Teléfono", "XXXXXXXXX"),
                        ("Correo", "......@gmail.com")
                    ])

                    infoCard(title: "Agenda y Estatus", content: [
                        ("Agenda", "Link"),
                        ("Estatus", "Activo")
                    ])
                }
                .padding()

                // Action buttons
                VStack(spacing: 16) {
                    Button(action: {
                        // Acción para editar información
                    }) {
                        Text("Editar información")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 5)
                    }

                    Button(action: {
                        // Acción para cerrar sesión
                    }) {
                        Text("Cerrar sesión")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.red)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .shadow(color: Color.red.opacity(0.3), radius: 5, x: 0, y: 5)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)

                Spacer()
            }
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.bottom)
        .overlay(
            // Bottom navigation bar
            HStack {
                navButton(icon: "magnifyingglass", text: "Explorar")
                Spacer()
                navButton(icon: "heart", text: "Clientes")
                Spacer()
                navButton(icon: "book", text: "Biblioteca")
                Spacer()
                navButton(icon: "person.fill", text: "Perfil", isActive: true)
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.white)
            .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: -5)
            , alignment: .bottom
        )
    }

    private func infoCard(title: String, content: [(String, String)]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 5)

            ForEach(content, id: \.0) { item in
                HStack {
                    Text(item.0)
                        .foregroundColor(.secondary)
                    Spacer()
                    Text(item.1)
                        .fontWeight(.medium)
                }
            }
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }

    private func navButton(icon: String, text: String, isActive: Bool = false) -> some View {
        VStack {
            Image(systemName: isActive ? icon + ".fill" : icon)
                .foregroundColor(isActive ? .blue : .gray)
            Text(text)
                .font(.caption)
                .foregroundColor(isActive ? .blue : .gray)
        }
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView()
    }
}

