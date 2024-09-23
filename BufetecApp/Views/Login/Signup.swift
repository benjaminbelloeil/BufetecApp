import SwiftUI
import AuthenticationServices

struct Signup: View {
    @Binding var showSignup: Bool
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showQuestions = false

    private var isFormFilled: Bool {
        !name.isEmpty && !email.isEmpty && !password.isEmpty
    }

    var body: some View {
        ZStack {
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
                    Text("Or")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                    Divider()
                        .frame(width: 100, height: 1)
                        .background(Color.gray)
                }
                
                VStack(spacing: 15) {
                    TextField("Nombre", text: $name)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    TextField("Correo Electrónico/Teléfono", text: $email)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    
                    HStack {
                        if showPassword {
                            TextField("Contraseña", text: $password)
                        } else {
                            SecureField("Contraseña", text: $password)
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
                    // Add signup functionality and validation before showing questions
                    showQuestions = true
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
        }
        .fullScreenCover(isPresented: $showQuestions) {
            QuestionView(showQuestions: $showQuestions)
        }
    }
}

#Preview {
    ContentView()
}
