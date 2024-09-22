//
//  OTPView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 8/14/24.
//

import SwiftUI

struct OTPView: View {
    @Binding var otpText: String
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
            
            Text("Enter OTP")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .padding(.top, 5)
            
            Text("A 6 digit code has been sent to your email")
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields for OTP

                /// Signup Button
                GradientButton(title: "Send Link", icon: "arrow.right") {

                }
                .hSpacing(.trailing)
                /// Disabling unit the  Data is entered
                .disabledWithOpacity(otpText.isEmpty)
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
