import SwiftUI

struct PerfilView: View {
    let abogadoId: String
    @State private var nombre: String = ""
    @State private var especializacion: String = ""
    @State private var experienciaProfesional: String = ""
    @State private var disponibilidad: String = ""
    @State private var maestria: String = ""
    @State private var direccion: String = ""
    @State private var casosAsignados: String = ""
    @State private var telefono: String = ""
    @State private var correo: String = ""
    @State private var casosAtendidos: String = ""
    @State private var casosConSentenciaAFavor: String = ""
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?

    var body: some View {
        ScrollView {
            VStack {
                if isLoading {
                    ProgressView("Loading...")
                } else if let errorMessage = errorMessage {
                    Text("Error: \(errorMessage)")
                } else {
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

                                Text(String(nombre.prefix(1)))
                                    .font(.system(size: 40, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .overlay(Circle().stroke(Color.white, lineWidth: 3))
                            .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
                            .padding(.top, 8)

                            Text(nombre)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .padding(.top, 8)

                            Text("Abogado")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .padding(.top, 2)
                        }
                        .padding(.bottom, 8)
                        .background(Color(.systemBackground))

                        // Information cards
                        VStack(spacing: 20) {
                            infoCard(title: "Información Personal", content: [
                                ("Especialización", especializacion),
                                ("Experiencia Profesional", experienciaProfesional),
                                ("Disponibilidad", disponibilidad),
                                ("Maestría", maestria),
                                ("Dirección", direccion),
                                ("Casos Asignados", casosAsignados),
                                ("Teléfono", telefono),
                                ("Correo", correo),
                                ("Casos Atendidos", casosAtendidos),
                                ("Casos con Sentencia a Favor", casosConSentenciaAFavor)
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
        }
        .background(Color(.systemBackground))
        .onAppear {
            fetchLawyerData()
        }
    }

    private func fetchLawyerData() {
        guard let url = URL(string: "http://localhost:5001/lawyer/\(abogadoId)") else {
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No data received"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.nombre = json["nombre"] as? String ?? "N/A"
                        self.especializacion = json["especializacion"] as? String ?? "N/A"
                        self.experienciaProfesional = json["experiencia_profesional"] as? String ?? "N/A"
                        self.disponibilidad = json["disponibilidad"] as? String ?? "N/A"
                        self.maestria = json["maestria"] as? String ?? "N/A"
                        let direccionDict = json["direccion"] as? [String: String] ?? [:]
                        self.direccion = "\(direccionDict["calle"] ?? ""), \(direccionDict["ciudad"] ?? ""), \(direccionDict["estado"] ?? ""), \(direccionDict["codigo_postal"] ?? "")"
                        self.casosAsignados = json["casos_asignados"] as? String ?? "N/A"
                        self.telefono = json["telefono"] as? String ?? "N/A"
                        self.correo = json["correo"] as? String ?? "N/A"
                        self.casosAtendidos = json["casos_atendidos"] as? String ?? "N/A"
                        self.casosConSentenciaAFavor = json["casos_con_sentencia_a_favor"] as? String ?? "N/A"
                    } else {
                        self.errorMessage = "Invalid JSON structure"
                    }
                } catch {
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
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
        PerfilView(abogadoId: "6706c745dfc597d5f283d303d")
    }
}