//
//  DocumentDetailView.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 25/09/24.
//

import SwiftUI

struct DocumentDetailView: View {
    var documento: Documento // El modelo de documento

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                // Título del documento
                Text(documento.nombreDocumento)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                // Autor del documento (si está disponible)
                Text("Autor desconocido")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                // Imagen de la portada (si está disponible)
                AsyncImage(url: URL(string: documento.urlDocumento)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 220)
                } placeholder: {
                    Image(systemName: "doc.text")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 220)
                        .background(Color(.systemGray5))
                        .cornerRadius(8)
                }

                // Botones: Preguntar y Descargar
                HStack(spacing: 20) {
                    Button(action: {
                        // Acción de preguntar
                    }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Preguntar")
                        }
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }

                    Button(action: {
                        // Acción de descargar
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Descargar")
                        }
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.2))
                        .foregroundColor(.blue)
                        .cornerRadius(8)
                    }
                }
                .padding(.horizontal)
            }
            .padding()
        }
        .navigationTitle(documento.nombreDocumento)
    }
}

#Preview {
    let dummyDocumento = Documento(
        id: "1",
        casoId: "123",
        userId: "235",
        nombreDocumento: "Sentencia de divorcio",
        tipoDocumento: "Sentencia",
        urlDocumento: "https://example.com/sentencia.pdf",
        status: "Activo",
        createdAt: Date()
    )
    
    DocumentDetailView(documento: dummyDocumento)
}
