import SwiftUI

struct PerfilView: View {
    let userId: String
    @State private var userData: [String: Any] = [:]
    @State private var isLoading: Bool = true
    @State private var errorMessage: String?
    @State private var shouldNavigateToLogin: Bool = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    if isLoading {
                        ProgressView("Cargando...")
                    } else if let errorMessage = errorMessage {
                        ErrorView(message: errorMessage)
                    } else {
                        profileHeader
                        informationCard
                        logoutButton
                    }
                }
                .padding(.vertical)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Mi perfil")
            .onAppear {
                fetchUserData()
            }
            .navigationDestination(isPresented: $shouldNavigateToLogin) {
                Login(showSignup: .constant(false), showIntro: .constant(false))
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(width: 100, height: 100)
                
                Text(String(userData["nombre"] as? String ?? "").prefix(1).uppercased())
                    .font(.system(size: 40, weight: .bold))
                    .foregroundColor(.white)
            }
            
            Text(userData["nombre"] as? String ?? "")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text((userData["rol"] as? String ?? "").capitalized)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
    }

    private var informationCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información Personal")
                .font(.headline)
                .fontWeight(.semibold)
            
            ForEach(sortedUserDataKeys(), id: \.self) { key in
                if !["nombre", "rol", "id"].contains(key) {
                    InfoRows(key: key, value: userData[key])
                }
            }
        }
        .padding(20)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
    }

    private var logoutButton: some View {
        Button(action: {
        }) {
            Text("Cerrar sesión")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.red)
                .foregroundColor(.white)
                .cornerRadius(12)
        }
        .padding(.horizontal, 16)
    }

    private func fetchUserData() {
        guard let url = URL(string: "http://10.14.255.54:5001/user/\(userId)") else {
            self.errorMessage = "URL inválida"
            self.isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false

                if let error = error {
                    self.errorMessage = "Error de red: \(error.localizedDescription)"
                    return
                }

                guard let data = data else {
                    self.errorMessage = "No se recibieron datos"
                    return
                }

                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        self.userData = json
                    } else {
                        self.errorMessage = "Estructura JSON inválida"
                    }
                } catch {
                    self.errorMessage = "Error de decodificación: \(error.localizedDescription)"
                }
            }
        }.resume()
    }

    private func sortedUserDataKeys() -> [String] {
        let order = ["correo_o_telefono", "contacto", "especializacion", "experiencia_profesional", "disponibilidad", "maestria", "direccion", "casos_asignados", "casos_atendidos", "casos_con_sentencia_a_favor", "fecha_inicio", "proxima_audiencia", "url_recurso"]
        return userData.keys.sorted { (key1, key2) -> Bool in
            order.firstIndex(of: key1) ?? Int.max < order.firstIndex(of: key2) ?? Int.max
        }
    }
}

struct InfoRows: View {
    let key: String
    let value: Any?

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(formatFieldName(key))
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if key == "direccion" {
                if let dictValue = value as? [String: Any] {
                    ForEach(["calle", "ciudad", "estado", "codigo_postal"], id: \.self) { subKey in
                        if let subValue = dictValue[subKey] as? String, !subValue.isEmpty {
                            Text(subValue)
                                .font(.body)
                        }
                    }
                }
            } else {
                Text(formatFieldValue(value))
                    .font(.body)
            }
        }
    }

    private func formatFieldName(_ name: String) -> String {
        name.split(separator: "_")
            .map { $0.prefix(1).uppercased() + $0.dropFirst().lowercased() }
            .joined(separator: " ")
    }

    private func formatFieldValue(_ value: Any?) -> String {
        switch value {
        case let string as String:
            return string.isEmpty ? "N/A" : string
        case let number as NSNumber:
            return number.stringValue
        case let date as Date:
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter.string(from: date)
        case let array as [Any]:
            return array.isEmpty ? "N/A" : "(\n\(array.map { "  \(formatFieldValue($0))" }.joined(separator: ",\n"))\n)"
        case .none, is NSNull:
            return "N/A"
        default:
            return String(describing: value ?? "N/A")
        }
    }
}

struct ErrorView: View {
    let message: String

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle")
                .font(.largeTitle)
                .foregroundColor(.red)
            Text("Error")
                .font(.headline)
                .padding(.top)
            Text(message)
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct PerfilView_Previews: PreviewProvider {
    static var previews: some View {
        PerfilView(userId: "670d6c4fc0cad37765214a64")
    }
}
