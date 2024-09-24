//
//  BibliotecaView.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import SwiftUI

struct BibliotecaView: View {
    @ObservedObject var viewModel = BibliotecaViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    // Sección "Continuar explorando"
                    Text("Continuar explorando")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.bibliotecas) { biblioteca in
                                VStack {
                                    // Puedes personalizar la imagen según el tipo de recurso
                                    Image(systemName: "book")
                                        .resizable()
                                        .frame(width: 100, height: 150)
                                    
                                    Text(biblioteca.titulo)
                                        .font(.caption)
                                        .frame(width: 100)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.leading)
                            }
                        }
                    }
                    
                    // Sección "Tus documentos"
                    Text("Tus documentos")
                        .font(.headline)
                        .padding(.leading)
                    
                    ForEach(viewModel.documentos) { documento in
                        HStack {
                            // Puedes personalizar el ícono según el tipo de documento
                            Image(systemName: "doc.text")
                                .resizable()
                                .frame(width: 50, height: 50)
                            
                            VStack(alignment: .leading) {
                                Text(documento.nombreDocumento)
                                    .font(.subheadline)
                                Text("Tipo: \(documento.tipoDocumento)")
                                    .font(.caption)
                            }
                        }
                        .padding()
                    }
                }
            }
            .navigationTitle("Biblioteca Legal")
        }
    }
}

#Preview {
    BibliotecaView()
}
