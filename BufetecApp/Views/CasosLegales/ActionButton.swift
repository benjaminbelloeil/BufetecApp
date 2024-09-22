//
//  ActionButton.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//

// ActionButton.swift
import SwiftUI

struct ActionButton: View {
    let title: String
    let color: Color
    let systemImage: String?
    let action: () -> Void

    // Inicializador explícito para manejar parámetros opcionales
    init(title: String, color: Color, systemImage: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.color = color
        self.systemImage = systemImage
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack {
                if let systemImage = systemImage {
                    Image(systemName: systemImage)
                        .font(.headline)
                }
                Text(title)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct ActionButton_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            // Acción con icono
            ActionButton(title: "Añadir", color: .blue, systemImage: "plus") {
                print("Añadir")
            }
            .padding()
            .previewLayout(.sizeThatFits)

            // Acción sin icono
            ActionButton(title: "Eliminar", color: .red) {
                print("Eliminar")
            }
            .padding()
            .previewLayout(.sizeThatFits)
        }
    }
}

