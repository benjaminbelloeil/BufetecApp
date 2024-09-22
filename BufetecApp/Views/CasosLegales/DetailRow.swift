//
//  DetailRow.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//

// DetailRow.swift
import SwiftUI

struct DetailRow: View {
    let title: String
    let value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.medium)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
    }
}

struct DetailRow_Previews: PreviewProvider {
    static var previews: some View {
        DetailRow(title: "Nombre del caso", value: "Prueba Caso")
            .padding()
            .previewLayout(.sizeThatFits)
    }
}

