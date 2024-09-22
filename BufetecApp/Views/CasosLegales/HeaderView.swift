//
//  HeaderView.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//

// HeaderView.swift
import SwiftUI

struct HeaderView: View {
    let backAction: () -> Void
    let addCaseAction: () -> Void

    var body: some View {
        HStack {
            Button(action: backAction) {
                Image(systemName: "arrow.left")
                    .font(.title2)
                    .foregroundColor(.blue)
            }

            Spacer()

            Text("BUFFETEC")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.primary)

            Spacer()

            ActionButton(title: "Añadir Caso", color: .blue, systemImage: "plus") {
                addCaseAction()
            }
            .frame(width: 120) // Ajusta el ancho según sea necesario
        }
        .padding(.bottom, 10)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(backAction: {
            print("Volver atrás")
        }, addCaseAction: {
            print("Añadir caso")
        })
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
