//
//  ClientCard.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//

// ClientCard.swift
import SwiftUI

struct ClientCard: View {
    let client: Client

    var body: some View {
        VStack {
            Circle()
                .fill(Color.blue.opacity(0.3))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(String(client.name.prefix(1)))
                        .font(.title)
                        .foregroundColor(.blue)
                )

            Text(client.name)
                .font(.subheadline)
                .foregroundColor(.primary)
        }
        .padding()
        .background(Color.gray.opacity(0.05))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}

struct ClientCard_Previews: PreviewProvider {
    static var previews: some View {
        ClientCard(client: Client(id: 1, name: "Cliente Ejemplo"))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

