import SwiftUI

struct DocumentDetailView: View {
    var documento: Documento
    @State private var showingChatView = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                // Document cover and title
                HStack(alignment: .top, spacing: 20) {
                    AsyncImage(url: URL(string: documento.urlDocumento)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 160)
                            .cornerRadius(10)
                            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    } placeholder: {
                        ZStack {
                            Color(.systemGray5)
                            Image(systemName: "doc.text.fill")
                                .resizable()
                                .scaledToFit()
                                .foregroundColor(.blue)
                                .padding(30)
                        }
                        .frame(width: 120, height: 160)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(documento.nombreDocumento)
                            .font(.title2)
                            .fontWeight(.bold)
                            .fixedSize(horizontal: false, vertical: true)

                        Text("Autor desconocido")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Tipo: \(documento.tipoDocumento)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        Text("Estado: \(documento.status)")
                            .font(.subheadline)
                            .foregroundColor(documento.status == "Activo" ? .green : .red)

                        Text("Creado: \(formattedDate(documento.createdAt))")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.bottom)

                // Document details
                VStack(alignment: .leading, spacing: 16) {
                    detailRow(title: "ID del Caso", value: documento.casoId)
                    detailRow(title: "ID del Usuario", value: documento.userId)
                    detailRow(title: "URL del Documento", value: documento.urlDocumento)
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
                            Text("Preguntar sobre este documento")
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
                            Text("Descargar documento")
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
        .navigationTitle("Detalles del Documento")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $showingChatView) {
            ChatView(viewModel: ChatViewModel(), documentId: documento.id, userId: documento.userId)
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
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct DocumentDetailView_Previews: PreviewProvider {
    static var previews: some View {
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
        
        NavigationView {
            DocumentDetailView(documento: dummyDocumento)
        }
    }
}
