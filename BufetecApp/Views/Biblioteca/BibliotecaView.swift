import SwiftUI

struct BibliotecaView: View {
    @ObservedObject var viewModel = BibliotecaViewModel()
    @State private var searchQuery: String = ""


    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // Search bar
                    TextField("Search", text: $searchQuery)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)

                    
                    // Sección "Continuar explorando"
                    Text("Continuar explorando")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.obtenerDocumentosDeChats().filter { searchQuery.isEmpty || $0.nombreDocumento.localizedCaseInsensitiveContains(searchQuery) }) { documento in
                            NavigationLink(destination: DocumentDetailView(documento: documento)) {
                                    VStack {
                                        Image(systemName: "doc.text")
                                            .resizable()
                                            .frame(width: 100, height: 150)
                                        Text(documento.nombreDocumento)
                                            .font(.caption)
                                            .frame(width: 100)
                                            .multilineTextAlignment(.center)
                                        Text("Autor desconocido")
                                            .font(.caption2)
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                    }
                    
                    // Sección "Para ti"
                    Text("Para ti")
                        .font(.headline)
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.obtenerSugerencias(tipoProceso: "Divorcio").filter { searchQuery.isEmpty || $0.titulo.localizedCaseInsensitiveContains(searchQuery) }) { biblioteca in
                            NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                                    VStack {
                                        // Imagen de portada
                                        ZStack {
                                            Rectangle() // El contenedor de la imagen
                                                .frame(width: 100, height: 150)
                                                .foregroundColor(.gray) // Color de fondo si no hay imagen (opcional)
                                            AsyncImage(url: URL(string: biblioteca.portada)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill() // Escala la imagen para llenar el contenedor
                                                    .frame(width: 100, height: 150)
                                                    .clipped() // Recorta cualquier desbordamiento de la imagen
                                            } placeholder: {
                                                // Placeholder mientras se carga la imagen
                                                Image(systemName: "book")
                                                    .resizable()
                                                    .frame(width: 100, height: 150)
                                            }
                                        }
                                        
                                        // Título del libro
                                        Text(biblioteca.titulo)
                                            .font(.caption)
                                            .frame(width: 100)
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.black) // Texto en color negro

                                        // Autor del libro
                                        Text(biblioteca.autor)
                                            .font(.caption2)
                                            .foregroundColor(.black) // Texto en color negro
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
                    }

                    
                    // Sección "Tus documentos"
                    Text("Tus documentos")
                        .font(.headline)
                        .padding(.leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.obtenerDocumentosUsuario().filter { searchQuery.isEmpty || $0.nombreDocumento.localizedCaseInsensitiveContains(searchQuery) }) { documento in
                            NavigationLink(destination: DocumentDetailView(documento: documento)) {
                                    VStack {
                                        Image(systemName: "doc.text")
                                            .resizable()
                                            .frame(width: 100, height: 150)
                                        Text(documento.nombreDocumento)
                                            .font(.caption)
                                            .frame(width: 100)
                                            .multilineTextAlignment(.center)
                                        Text("Autor desconocido")
                                            .font(.caption2)
                                    }
                                    .padding(.leading)
                                }
                            }
                        }
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

