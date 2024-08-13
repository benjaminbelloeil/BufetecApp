//
//  CustomTF.swift
//  Buffetec
//
//  Created by Benjamin Belloeil on 8/12/24.
//

import SwiftUI

struct CustomTF: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    /// Hides Text Field
    var isPassword: Bool = false
    @Binding var value: String
    /// View Properties
    @State private var showPassword: Bool = false
    var body: some View {
        HStack (alignment: .top, spacing: 8, content: {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                /// Need Same Width to Align TextFields Equally
                .frame(width: 30)
                /// Slightly Bringing Down
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8, content:{
                if isPassword {
                    Group {
                        /// Reveals password when the user wants to reveal it
                        if showPassword {
                            TextField(hint, text: $value)
                        } else {
                            SecureField(hint, text: $value)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                }
                
                Divider()
            })
            .overlay(alignment: .trailing) {
                /// Password Reveal Button
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }
        })
    }
}

