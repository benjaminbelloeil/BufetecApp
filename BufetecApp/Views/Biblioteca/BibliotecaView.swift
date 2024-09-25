import SwiftUI

struct BibliotecaView: View {
    @ObservedObject var viewModel = BibliotecaViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    
                    // Search bar
                    TextField("Search", text: .constant(""))
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
                            ForEach(viewModel.obtenerDocumentosDeChats()) { documento in
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
                            ForEach(viewModel.obtenerSugerencias(tipoProceso: "Divorcio")) { biblioteca in
                                NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                                    VStack {
                                        Image(systemName: "book")
                                            .resizable()
                                            .frame(width: 100, height: 150)
                                        Text(biblioteca.titulo)
                                            .font(.caption)
                                            .frame(width: 100)
                                            .multilineTextAlignment(.center)
                                        Text(biblioteca.autor)
                                            .font(.caption2)
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
                            ForEach(viewModel.obtenerDocumentosUsuario()) { documento in
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

