//
//  BibliotecaDetailView.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//
import SwiftUI

struct BibliotecaDetailView: View {
    var biblioteca: Biblioteca // El modelo que contiene los datos del documento
    @State private var navigateToChat = false // State to control navigation

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 16) {
                // Título del documento
                Text(biblioteca.titulo)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                // Autor del documento (si está disponible)
                Text(biblioteca.autor)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)

                // Imagen de la portada (si está disponible)
                AsyncImage(url: URL(string: biblioteca.portada)) { image in
                    image
                        .resizable()
                        .scaledToFill() // Asegura que la imagen llene todo el frame
                        .frame(width: 150, height: 220)
                        .cornerRadius(8) // Borde redondeado
                        .clipped() // Recorta las partes que sobresalen del frame
                } placeholder: {
                    Image(systemName: "book")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 220)
                        .background(Color(.systemGray5))
                        .cornerRadius(8) // Borde redondeado también para el placeholder
                }

                // Descripción (si está disponible)
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción")
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    Text(biblioteca.descripcion)
                        .font(.body)
                        .foregroundColor(.gray)
                }
                .padding(.horizontal)

                // Botones: Preguntar y Descargar
                HStack(spacing: 20) {
                    // Navegación al Chat cuando se presiona "Preguntar"
                    NavigationLink(destination: ChatView(viewModel: ChatViewModel(), documentId: biblioteca.id, userId: "currentUserId")) {
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
        .navigationTitle(biblioteca.titulo)
        .navigationBarTitleDisplayMode(.inline) // Make title inline to save space
    }
}

#Preview {
    let dummyBiblioteca = Biblioteca(
        id: "1",
        titulo: "Constitución Política de los Estados Unidos Mexicanos",
        descripcion: "Libro epico",
        tipoRecurso: "Libro",
        categoria: "Derecho Constitucional",
        autor: "Aguilar Morales, Luis María",
        fechaCreacion: Date(),
        urlRecurso: "https://example.com/portada.jpg", // Imagen de ejemplo
        portada: "https://portada.com/hola.png",
        status: "Activo"
    )

    NavigationStack {
        BibliotecaDetailView(biblioteca: dummyBiblioteca)
    }
}
