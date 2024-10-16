import SwiftUI

struct BibliotecaView: View {
    @ObservedObject var viewModel = BibliotecaViewModel()
    @State private var searchQuery: String = ""
    
    // Constants for layout
    private let containerWidth: CGFloat = 320
    private let cardWidth: CGFloat = 160
    private let containerHeight: CGFloat = 240
    private let imageWidth: CGFloat = 120
    private let imageHeight: CGFloat = 160

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    searchBar
                    
                    continueExploringSection
                    
                    forYouSection
                    
                    yourDocumentsSection
                    
                    educationalVideosSection  // Sección de Videos Educativos
                }
                .padding(.top)
            }
            .background(Color(.systemBackground))
            .navigationTitle("Biblioteca Legal")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField("Buscar", text: $searchQuery)
                .autocapitalization(.none)
                .disableAutocorrection(true)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private var continueExploringSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Continuar explorando")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredSuggestions(for: "Divorcio")) { biblioteca in
                        NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                            LargeBookCard(biblioteca: biblioteca)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var forYouSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Para ti")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredSuggestions(for: "Divorcio")) { biblioteca in
                        NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                            SmallBookCard(biblioteca: biblioteca)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var yourDocumentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Tus documentos")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredDocuments()) { documento in
                        NavigationLink(destination: DocumentDetailView(documento: documento)) {
                            DocumentCard(documento: documento)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private var educationalVideosSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader(title: "Videos Educativos")
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(filteredVideos()) { video in
                        NavigationLink(destination: VideoDetailView(video: video)) {
                            VideoCard(video: video)
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
    
    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.title2)
            .fontWeight(.bold)
            .padding(.horizontal)
    }
    
    private func filteredSuggestions(for tipoProceso: String) -> [Biblioteca] {
        viewModel.obtenerSugerencias(tipoProceso: tipoProceso).filter {
            searchQuery.isEmpty || $0.titulo.localizedCaseInsensitiveContains(searchQuery)
        }
    }
    
    private func filteredDocuments() -> [Documento] {
        viewModel.obtenerDocumentosUsuario().filter {
            searchQuery.isEmpty || $0.nombreDocumento.localizedCaseInsensitiveContains(searchQuery)
        }
    }

    private func filteredVideos() -> [Video] {
        viewModel.obtenerVideosEducativos().filter {
            searchQuery.isEmpty || $0.titulo.localizedCaseInsensitiveContains(searchQuery)
        }
    }
}

struct LargeBookCard: View {
    let biblioteca: Biblioteca
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: biblioteca.portada)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 200)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 160, height: 200)
                    .overlay(Image(systemName: "book").foregroundColor(.white))
            }
            .cornerRadius(10)
            
            Text(biblioteca.titulo)
                .font(.headline)
                .lineLimit(2)
            
            Text(biblioteca.autor)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(width: 160)
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct SmallBookCard: View {
    let biblioteca: Biblioteca
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: biblioteca.portada)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 160)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 120, height: 160)
                    .overlay(Image(systemName: "book").foregroundColor(.white))
            }
            .cornerRadius(10)
            
            Text(biblioteca.titulo)
                .font(.caption)
                .lineLimit(2)
            
            Text(biblioteca.autor)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct DocumentCard: View {
    let documento: Documento
    
    var body: some View {
        VStack(alignment: .leading) {
            ZStack {
                Color(.systemGray6)
                    .frame(width: 120, height: 160)
                    .cornerRadius(10)
                
                Image(systemName: "doc.text")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 60, height: 60)
                    .foregroundColor(.blue)
            }
            
            Text(documento.nombreDocumento)
                .font(.caption)
                .lineLimit(2)
            
            Text("Documento personal")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct VideoCard: View {
    let video: Video
    
    var body: some View {
        VStack(alignment: .leading) {
            AsyncImage(url: URL(string: video.thumbnailURL)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 120, height: 160)
                    .clipped()
            } placeholder: {
                Color.gray
                    .frame(width: 120, height: 160)
                    .overlay(Image(systemName: "video").foregroundColor(.white))
            }
            .cornerRadius(10)
            
            Text(video.titulo)
                .font(.caption)
                .lineLimit(2)
            
            Text(video.duracion)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 120)
        .padding(8)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct BibliotecaView_Previews: PreviewProvider {
    static var previews: some View {
        BibliotecaView()
    }
}
