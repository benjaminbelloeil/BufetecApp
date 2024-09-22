//
//  ForgotPassword.swift
//  Buffetec
//
//  Created by Benjamin Belloeil on 8/13/24.
//

import SwiftUI

struct ForgotPassword: View {
    @Binding var showResetView: Bool
    /// View properties
    @State private var emailID: String = ""
    /// Environment properties
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        VStack ( alignment: .leading, spacing: 15, content: {
            /// Back button
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundStyle(.gray)
            })
            .padding(.top, 10)
            
            Text("Forgot Password")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("Please enter your email so we can send you a reset link")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields

                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)

                /// Signup Button
                GradientButton(title: "Send Link", icon: "arrow.right") {
                    /// Own code here:
                    /// After the link is sent
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        /// showing the reset view
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                /// Disabling unit the  Data is entered
                .disabledWithOpacity(emailID.isEmpty)
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
