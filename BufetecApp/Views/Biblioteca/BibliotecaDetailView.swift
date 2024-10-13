import SwiftUI

struct BibliotecaDetailView: View {
    var biblioteca: Biblioteca
    @State private var showingChatView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Book cover and title
                HStack(alignment: .top, spacing: 20) {
                    AsyncImage(url: URL(string: biblioteca.portada)) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 120, height: 180)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    } placeholder: {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "book.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .padding(30)
                        }
                        .frame(width: 120, height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(biblioteca.titulo)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)

                        Text(biblioteca.autor)
                            .font(.headline)
                            .foregroundColor(.secondary)

                        Text("Categoría: \(biblioteca.categoria)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Tipo: \(biblioteca.tipoRecurso)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Estado: \(biblioteca.status)")
                            .font(.subheadline)
                            .foregroundColor(biblioteca.status == "Activo" ? .green : .red)
                    }
                }
                .padding(.bottom)

                // Description
                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripción")
                        .font(.headline)
                    
                    Text(biblioteca.descripcion)
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Additional details
                VStack(alignment: .leading, spacing: 16) {
                    detailRow(title: "Fecha de Creación", value: formattedDate(biblioteca.fechaCreacion))
                    detailRow(title: "URL del Recurso", value: biblioteca.urlRecurso)
                }
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(10)

                // Buttons
                VStack(spacing: 16) {
                    Button(action: {
                        showingChatView = true
                    }) {
                        HStack {
                            Image(systemName: "bubble.left.and.bubble.right.fill")
                            Text("Preguntar sobre este libro")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }

                    Button(action: {
                        // Acción de descargar
                    }) {
                        HStack {
                            Image(systemName: "arrow.down.circle.fill")
                            Text("Descargar libro")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue.opacity(0.1))
                        .foregroundColor(.blue)
                        .cornerRadius(10)
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detalles del Libro")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingChatView) {
            ChatView(viewModel: ChatViewModel(), documentId: biblioteca.id, userId: "currentUserId")
        }
    }

    private func detailRow(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            Text(value)
                .font(.body)
        }
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct BibliotecaDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyBiblioteca = Biblioteca(
            id: "1",
            titulo: "Constitución Política de los Estados Unidos Mexicanos",
            descripcion: "Este libro contiene el texto completo de la Constitución Política de los Estados Unidos Mexicanos, incluyendo todas las reformas y adiciones hasta la fecha. Es una herramienta esencial para estudiantes de derecho, abogados y cualquier persona interesada en el sistema legal mexicano.",
            tipoRecurso: "Libro",
            categoria: "Derecho Constitucional",
            autor: "Aguilar Morales, Luis María",
            fechaCreacion: Date(),
            urlRecurso: "https://example.com/constitucion.pdf",
            portada: "https://example.com/portada-constitucion.jpg",
            status: "Activo"
        )

        NavigationView {
            BibliotecaDetailView(biblioteca: dummyBiblioteca)
        }
    }
}
