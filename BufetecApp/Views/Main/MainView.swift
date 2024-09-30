import SwiftUI

struct MainView: View {
    @State private var userType: UserType?
    typealias UserType = BufetecApp.UserType
    @State private var isLoading = true
    let userId: String

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...") as ProgressView<Text, EmptyView>
            } else if let userType = userType {
                switch userType {
                case .cliente:
                    ClienteMainView(userId: userId)
                case .abogado:
                    AbogadoMainView(userId: userId)
                case .estudiante:
                    EstudianteMainView(userId: userId)
                }
            } else {
                Text("Error: User type not determined")
            }
        }
        .onAppear {
            fetchUserData()
        }
    }

    private func fetchUserData() {
        guard let url = URL(string: "http://localhost:5001/user/\(userId)") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let rol = json["rol"] as? String {
                            self.userType = UserType(rawValue: rol)
                        }
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error al decodificar la respuesta: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userId: "sampleUserId")
    }
}
