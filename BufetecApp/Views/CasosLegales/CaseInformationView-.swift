//
//  CaseInformationView-.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//
import SwiftUI

struct CaseInformationView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            DetailRow(title: "Nombre del caso", value: "Prueba Caso")
            DetailRow(title: "#Expediente", value: "111111")
            DetailRow(title: "Parte Actora", value: "Nombre")
            DetailRow(title: "Parte Demandada", value: "Nombre")
            DetailRow(title: "Seguimiento", value: "Activo")
            DetailRow(title: "Perfil Cliente", value: "Perfil")
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
        .padding(.horizontal)
    }
}

struct CaseInformationView_Previews: PreviewProvider {
    static var previews: some View {
        CaseInformationView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
