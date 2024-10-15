import SwiftUI
import AuthenticationServices

struct Signup: View {
    @Binding var showSignup: Bool
    @State private var nombre: String = ""
    @State private var correo_o_telefono: String = ""
    @State private var contrasena: String = ""
    @State private var showPassword: Bool = false
    @State private var showQuestions = false
    @State private var errorMessage: String = ""
    @State private var tempUserId: String = ""

    private var isFormFilled: Bool {
        !nombre.isEmpty && !correo_o_telefono.isEmpty && !contrasena.isEmpty
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Regístrate")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "3B5998"))
                
                Text("Asesoría jurídica gratuita y trámites notariales a menor costo, con calidad garantizada.")
                    .font(.subheadline)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                    .foregroundColor(.gray)
                
                HStack(spacing: 20) {
                    Button(action: {
                        // Implement Apple sign in
                    }) {
                        HStack {
                            Image(systemName: "apple.logo")
                            Text("Apple")
                        }
                        .frame(maxWidth: .infinity)
                        .foregroundColor(Color.black)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                    
                    Button(action: {
                        // Implement Google sign in
                    }) {
                        HStack {
                            Image("Google")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 20, height: 20)
                            Text("Google")
                            .foregroundColor(Color.black)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
                .padding(.horizontal)
                
                HStack {
                    Divider()
                        .frame(width: 100, height: 1)
                        .background(Color.gray)
                    Text("O")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Divider()
                        .frame(width: 100, height: 1)
                        .background(Color.gray)
                }
                
                VStack(spacing: 15) {
                    TextField("Nombre", text: $nombre)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    TextField("Correo Electrónico/Teléfono", text: $correo_o_telefono)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    HStack {
                        if showPassword {
                            TextField("Contraseña", text: $contrasena)
                        } else {
                            SecureField("Contraseña", text: $contrasena)
                        }
                        
                        Button(action: {
                            showPassword.toggle()
                        }) {
                            Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                .padding(.horizontal)
                
                Button(action: {
                    signupUser()
                }) {
                    Text("Crear Cuenta")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormFilled ? Color(.blue) : Color(hex: "8EC5FC"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                .disabled(!isFormFilled)

                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                HStack {
                    Text("¿Tienes cuenta?")
                    Button("Inicia Sesión") {
                        showSignup = false
                    }
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "3B5998"))
                }
                .font(.footnote)
            }
            .padding()
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showQuestions) {
            QuestionView(showQuestions: $showQuestions, userId: $tempUserId)
        }
    }

    private func signupUser() {
        guard let url = URL(string: "http://10.14.255.54:5001/signup") else {
            print("URL inválida")
            return
        }

        let parameters = ["nombre": nombre, "correo_o_telefono": correo_o_telefono, "contrasena": contrasena]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            print("Error: \(error.localizedDescription)")
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    self.errorMessage = "No se recibieron datos"
                }
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let mensaje = json["mensaje"] as? String, mensaje == "Registro iniciado" {
                            if let tempUserId = json["temp_user_id"] as? String {
                                self.tempUserId = tempUserId
                                self.showQuestions = true
                            }
                            self.errorMessage = ""
                        } else if let error = json["error"] as? String {
                            self.errorMessage = error
                        }
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Error al decodificar la respuesta: \(error.localizedDescription)"
                }
            }
        }.resume()
    }
}

#Preview {
    Signup(showSignup: .constant(true))
}
