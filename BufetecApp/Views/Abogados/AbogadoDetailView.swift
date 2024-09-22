//
//  AbogadoDetailView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/21/24.
//

import SwiftUI

struct AbogadoDetailView: View {
    var lawyer: Lawyer

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Campo de búsqueda
            TextField("Buscar...", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)

            // Detalle del abogado dentro de una tarjeta azul
            VStack(alignment: .leading, spacing: 10) {
                // Imagen del abogado centrada
                HStack {
                    Spacer()
                    Image(lawyer.imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 180)
                        .clipShape(Circle())
                        .padding(.top)
                    Spacer()
                }

                // Información del abogado
                Text("Nombre: \(lawyer.name)")
                    .font(.system(size: 20,weight: .bold))
                    .foregroundColor(.white)

                Text("Dirección: Zona Tec")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text("Casos Asociados: \(lawyer.caseType)")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text("Teléfono: XXXXXXXXXX")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text("Correo: ......@gmail.com")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text("Casos atendidos: 7")
                    .font(.system(size: 20))
                    .foregroundColor(.white)

                Text("Casos con sentencia a favor: 78%")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
            }
            .padding()
            .background(Color.blue)
            .cornerRadius(15)
            .padding(.horizontal, 20)  // Aumenta el padding para dar espacio alrededor

            Spacer()  // Añade un espaciador para que el contenido no esté tan comprimido
        }
        .navigationTitle("Abogados")  // Título de la vista
    }
}

#Preview {
    AbogadoDetailView(lawyer: Lawyer(name: "Lic. Ana María López",
                                    specialty: "Maestría en Derechos Procesal",
                                    caseType: "Problemas Familiares",
                                    imageName: "avatar1"))
}
