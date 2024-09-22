//
//  PasswordResetView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 8/14/24.
//

import SwiftUI

struct PasswordResetView: View {
    /// View properties
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    /// Environment properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack ( alignment: .leading, spacing: 15, content: {
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

                /// Signup Button
                GradientButton(title: "Send Link", icon: "arrow.right") {
                /// Reset password logic here

                }
                .hSpacing(.trailing)
                /// Disabling unit the  Data is entered
                .disabledWithOpacity(password.isEmpty || confirmPassword.isEmpty)
            }
            .padding(.top, 20)
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        /// Since this is going to be a sheet.
        .interactiveDismissDisabled()
    }
}

#Preview {
    ContentView()
}
