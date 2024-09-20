import SwiftUI
import AuthenticationServices

struct Login: View {
    @Binding var showSignup: Bool
    @Binding var showIntro: Bool
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showPassword: Bool = false
    @State private var showForgotPasswordView: Bool = false
    @State private var showResetView: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color(hex: "E6F3FF"), .white]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 20) {
                Text("Iniciar Sesión")
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
                    // Implement login functionality
                }) {
                    Text("Iniciar Sesión")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color(hex: "8EC5FC"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding(.horizontal)
                /*
                Button("Ver Intro") {
                    showIntro = true
                }
                .foregroundColor(Color(hex: "3B5998"))
                */
                VStack {
                    HStack{
                        Text("¿No tienes cuenta?")
                        Button("Regístrate") {
                            showSignup.toggle()
                        }
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "3B5998"))
                        
                    }
                    .padding(20)
                    Button("¿Olvidaste tu contraseña?") {
                        showForgotPasswordView = true
                    }
                    .foregroundColor(Color(hex: "3B5998"))
                    .fontWeight(.bold)
                }
                .font(.footnote)
            }
            .padding()
        }
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                PasswordResetView()
                    .presentationDetents([.height(350)])
                    .presentationCornerRadius(30)
            } else {
                PasswordResetView()
                    .presentationDetents([.height(350)])
            }
        })
    }
}

#Preview {
    ContentView()
}
