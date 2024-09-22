//
//  GradientButton.swift
//  Buffetec
//
//  Created by Benjamin Belloeil on 8/12/24.
//
import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    
    var body: some View {
        Button(action: onClick, label: {
            HStack {
                Text(title)
                Image(systemName: icon)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(Color(hex: "8EC5FC"))
            .cornerRadius(10)
        })
    }
}

#Preview {
    GradientButton(title: "Iniciar Sesión", icon: "arrow.right") {
        // Action
    }
}
