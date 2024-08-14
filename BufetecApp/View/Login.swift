//
//  Login.swift
//  Buffetec
//
//  Created by Benjamin Belloeil on 8/12/24.
//

import SwiftUI

struct Login: View {
    @Binding var showSignup: Bool
    /// View properties
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotPasswordView: Bool = false
    /// Reset Password View
    @State private var showResetView: Bool = false

    var body: some View {
        VStack ( alignment: .leading, spacing: 15, content: {
            Spacer(minLength: 0)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.heavy)
            
            Text("Please sign in to continue")
                .font(.callout)
                .fontWeight(.semibold)
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// Custom Text Fields
                CustomTF(sfIcon: "at", hint: "Email", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "Password", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("Forgot Paswword?"){
                    showForgotPasswordView.toggle()
                }
                .font(.callout)
                .fontWeight(.heavy)
                .hSpacing(.trailing)
                
                /// Login Button
                GradientButton(title: "Login", icon: "arrow.right") {
                    
                }
                .hSpacing(.trailing)
                /// Disabling unit the  Data is entered
                .disabledWithOpacity(emailID.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("Dont have an account?")
                    .foregroundStyle(.gray)
                
                Button("Sign Up") {
                    showSignup.toggle()
                }
                .fontWeight(.bold)
                .tint(.blue)
            }
            .font(.callout)
            .hSpacing()
        })
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
        /// Asking for email to send the reset link
        .sheet(isPresented: $showForgotPasswordView, content: {
            if #available(iOS 16.4, *) {
                /// To create a custom sheet radius
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotPassword(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
        /// Reset Password View
        .sheet(isPresented: $showResetView, content: {
            if #available(iOS 16.4, *) {
                /// To create a custom sheet radius
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
