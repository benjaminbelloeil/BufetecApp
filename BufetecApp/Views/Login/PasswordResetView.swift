import SwiftUI

struct PasswordResetView: View {
    /// View properties
    @State private var password: String = ""
    @State private var confirmPassword: String = ""

    /// Environment properties
    @Environment(\.dismiss) private var dismiss
    
    /// Check if the form is filled (both fields filled)
    private var isFormFilled: Bool {
        return !password.isEmpty && !confirmPassword.isEmpty
    }
    
    /// Check if the form is valid (both fields filled and passwords match)
    private var isFormValid: Bool {
        return isFormFilled && password == confirmPassword
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            /// Back button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "xmark")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("Reset Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "lock", hint: "Password", value: $password)
                CustomTF(sfIcon: "lock", hint: "Confirm Password", value: $confirmPassword)
                    .padding(.top, 5)

                /// Send Link Button
                Button(action: {
                    /// Reset password logic here
                }) {
                    Text("Enviar Link")
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isFormFilled ? Color.blue : Color(hex: "8EC5FC"))  // Blue if fields are filled, default color if not
                        .foregroundColor(.white)
                        .cornerRadius(10)  // Rounded corners
                }
                /// Disable the button until both fields are filled and passwords match
                .disabled(!isFormValid)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
    }
}

#Preview {
    PasswordResetView()
}
