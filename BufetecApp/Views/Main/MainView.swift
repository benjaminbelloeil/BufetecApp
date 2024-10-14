import SwiftUI

struct MainView: View {
    @State private var userType: UserType?
    @State private var errorMessage: String?
    typealias UserType = BufetecApp.UserType
    @State private var isLoading = true
    let userId: String
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
            } else if let userType = userType {
                switch userType {
                case .cliente:
                    ClienteMainView(userId: userId)
                case .abogado:
                    AbogadoMainView(userId: userId)
                case .estudiante:
                    EstudianteMainView(userId: userId)
                }
            } else if let errorMessage = errorMessage {
                VStack {
                    Text("Error: \(errorMessage)")
                    Button("Retry") {
                        isLoading = true
                        fetchUserData()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
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
            self.errorMessage = "Invalid URL"
            self.isLoading = false
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                self.isLoading = false
                
                if let httpResponse = response as? HTTPURLResponse {
                    print("HTTP Status Code: \(httpResponse.statusCode)")
                    if httpResponse.statusCode == 500 {
                        self.errorMessage = "Server error (500): Internal Server Error. Please try again later or contact support."
                        return
                    } else if httpResponse.statusCode != 200 {
                        self.errorMessage = "Server error: HTTP \(httpResponse.statusCode)"
                        return
                    }
                }
                
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    self.errorMessage = "Network error: \(error.localizedDescription)"
                    return
                }
                
                guard let data = data else {
                    print("No se recibieron datos")
                    self.errorMessage = "No data received"
                    return
                }
                
                // Print raw data for debugging
                if let dataString = String(data: data, encoding: .utf8) {
                    print("Raw data received: \(dataString)")
                }
                
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        print("Parsed JSON: \(json)")
                        if let rol = json["rol"] as? String {
                            self.userType = UserType(rawValue: rol)
                            if self.userType == nil {
                                self.errorMessage = "Invalid user type received: \(rol)"
                            }
                        } else {
                            self.errorMessage = "No 'rol' field in response"
                        }
                    } else {
                        self.errorMessage = "Invalid JSON structure"
                    }
                } catch {
                    print("Error al decodificar la respuesta: \(error.localizedDescription)")
                    self.errorMessage = "Decoding error: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userId: "66f45dad306974579379e3ee")
    }
}
