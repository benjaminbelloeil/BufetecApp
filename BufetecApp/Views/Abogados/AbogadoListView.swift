//
//  AbogadoListView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/21/24.
//

import SwiftUI

struct AbogadoListView: View {
    var lawyers: [Lawyer]  // Cambiamos a un array de abogados

    var body: some View {
        NavigationView {
            List(lawyers) { lawyer in
                HStack(alignment: .top) {
                    // Imagen del abogado
                    Image(lawyer.imageName)
                        .resizable()
                        .frame(width: 100, height: 60)
                        .clipShape(Circle())
                        .padding(.trailing, 10) // Espacio entre la imagen y el texto

                    // Información del abogado con íconos
                    VStack(alignment: .leading, spacing: 10) { // Aumenta el espacio entre los textos
                        HStack(alignment: .center, spacing: 10) {
                            Text(lawyer.name)
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        HStack(alignment: .center) {
                            Image(systemName: "folder")
                                .foregroundColor(.white)
                            Text(lawyer.specialty)
                                .font(.subheadline)
                                .foregroundColor(.white)
                        }

                        HStack(alignment: .center, spacing: 10) { // Espacio entre el ícono y el texto
                            Image(systemName: "doc")
                                .foregroundColor(.white)
                                .padding(.top, 10)
                            Text("Casos Asociado: \(lawyer.caseType)")
                                .font(.footnote)
                                .foregroundColor(.white)
                                .padding(.top, 5) // Alinea el texto con los íconos
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .lineLimit(2)
                        }
                    }
                }
                .frame(maxWidth: .infinity, minHeight: 150) // Asegura que las tarjetas ocupen todo el ancho disponible
                .padding(.vertical, 12) // Ajusta el padding vertical
                .padding(.horizontal, 20) // Aumenta el padding horizontal para hacer las tarjetas más anchas
                .background(Color.blue)
                .cornerRadius(10)
                .background(
                    NavigationLink(destination: AbogadoDetailView(lawyer: lawyer)) {
                        EmptyView()
                    }
                    .buttonStyle(PlainButtonStyle())
                    .opacity(0)
                )
            }
            .listStyle(PlainListStyle())  // Para eliminar cualquier estilo adicional de la lista
            .navigationTitle("Abogados")
        }
    }
}

#Preview {
    AbogadoListView(lawyers: [
        Lawyer(name: "Lic. Ana María López", specialty: "Derechos Procesal", caseType: "Problemas Familiares", imageName: "avatar1"),
        Lawyer(name: "Lic. Juan Pérez", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2"),
        Lawyer(name: "Lic. Moka Diaz", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2")
    ])
}
