import SwiftUI

struct BibliotecaView: View {
    @ObservedObject var viewModel = BibliotecaViewModel()
    @State private var searchQuery: String = ""
    // Variables to easily modify the size of the container
        let containerWidth: CGFloat = 320
        let cardWidth: CGFloat = 120
        let containerHeight: CGFloat = 160
        let imageWidth: CGFloat = 90
        let imageHeight: CGFloat = 120


    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Search bar
                    TextField("Search", text: $searchQuery)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .padding(.bottom, 2)
                
                VStack(alignment: .leading) {
                    // Sección "Continuar explorando"
                    Text("Continuar explorando")
                        .font(.headline)
                        .padding(.leading)
                        .padding(.top)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) { // Añadir espacio entre las tarjetas
                            ForEach(viewModel.obtenerSugerencias(tipoProceso: "Divorcio").filter { searchQuery.isEmpty || $0.titulo.localizedCaseInsensitiveContains(searchQuery) }) { biblioteca in
                                NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                                    HStack {
                                        // Contenedor de la imagen con color de fondo
                                        ZStack {
                                            Rectangle()
                                                .fill(Color(.teal)) // Fondo de color
                                                .frame(width: imageWidth + 30, height: imageHeight + 30) // Tamaño relativo del contenedor de la imagen
                                            
                                            // Imagen del documento (Portada)
                                            AsyncImage(url: URL(string: biblioteca.portada)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill() // Escala la imagen para llenar el contenedor
                                                    .frame(width: imageWidth, height: imageHeight)
                                                    .clipped() // Recorta cualquier desbordamiento de la imagen
                                            } placeholder: {
                                                // Placeholder mientras se carga la imagen
                                                Image(systemName: "doc.text")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .frame(width: imageWidth, height: imageHeight)
                                                    .clipped()
                                            }
                                        }
                                        
                                        // Título y autor a la derecha
                                        VStack(alignment: .leading, spacing: 5) {
                                            Text(biblioteca.titulo)
                                                .font(.callout) // Tamaño de texto para el título
                                                .fontWeight(.semibold)
                                                .foregroundColor(.black)
                                                .lineLimit(2) // Limitar a 2 líneas
                                                .truncationMode(.tail) // Mostrar puntos suspensivos (...) si el texto es largo
                                                .multilineTextAlignment(.leading) // Justificación a la izquierda

                                            Text(biblioteca.autor)
                                                .font(.caption) // Tamaño de texto para el autor
                                                .foregroundColor(.gray)
                                                .lineLimit(1) // Limitar a 1 línea
                                                .truncationMode(.tail) // Mostrar puntos suspensivos (...) si el texto es largo
                                                .multilineTextAlignment(.leading) // Justificación a la izquierda
                                        }
                                        .frame(maxWidth: .infinity, alignment: .leading) // Toma el ancho restante del contenedor

                                    }
                                    .background(Color(.white)) // Fondo claro para toda la tarjeta
                                    .cornerRadius(12) // Bordes redondeados para la tarjeta
                                    .shadow(radius: 1) // Sombra ligera
                                    .frame(width: containerWidth, height: containerHeight) // Tamaño total del contenedor
                                }
                            }
                        }
                        .padding(.leading)
                    }
                    
                    // Sección "Para ti"
                    Text("Para ti")
                        .font(.headline)
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) { // Ajustar el espacio entre las tarjetas
                            ForEach(viewModel.obtenerSugerencias(tipoProceso: "Divorcio").filter { searchQuery.isEmpty || $0.titulo.localizedCaseInsensitiveContains(searchQuery) }) { biblioteca in
                                NavigationLink(destination: BibliotecaDetailView(biblioteca: biblioteca)) {
                                    VStack {
                                        // Imagen de portada
                                        ZStack {
                                            Rectangle() // El contenedor de la imagen
                                                .frame(width: imageWidth + 30, height: imageHeight) // Tamaño más pequeño para la imagen
                                                .foregroundColor(.white) // Fondo blanco
                                                .cornerRadius(8) // Bordes redondeados
                                                .shadow(radius: 2) // Sombra ligera
                                            
                                            AsyncImage(url: URL(string: biblioteca.portada)) { image in
                                                image
                                                    .resizable()
                                                    .scaledToFill() // Escala la imagen para llenar el contenedor
                                                    .frame(width: imageWidth, height: imageHeight)
                                                    .clipped() // Recorta cualquier desbordamiento de la imagen
                                            } placeholder: {
                                                // Placeholder mientras se carga la imagen
                                                Image(systemName: "book")
                                                    .resizable()
                                                    .frame(width: 80, height: 120)
                                            }
                                        }

                                        VStack {
                                            // Título del libro
                                            Text(biblioteca.titulo)
                                                .font(.caption)
                                                .lineLimit(1) // Limitar a 2 líneas
                                                .truncationMode(.tail) // Mostrar puntos suspensivos si el texto es largo
                                                .multilineTextAlignment(.center)
                                                .foregroundColor(.black) // Texto en color negro
                                                .frame(width: 100) // Ajustar el ancho para que coincida con la imagen
                                            
                                            // Autor del libro
                                            Text(biblioteca.autor)
                                                .font(.caption2)
                                                .lineLimit(1) // Limitar a 1 línea
                                                .truncationMode(.tail) // Mostrar puntos suspensivos si el texto es largo
                                                .foregroundColor(.gray) // Texto en color gris
                                                .frame(width: 120)
                                        }
                                    }
                                    .background(Color.white) // Fondo blanco para la tarjeta
                                    .cornerRadius(12) // Bordes redondeados para la tarjeta
                                    .shadow(radius: 2) // Sombra ligera
                                    .frame(width: cardWidth, height: containerHeight) // Tamaño total del contenedor más pequeño
                                    .padding(.leading, 0)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }

                    // Sección "Tus documentos"
                    Text("Tus documentos")
                        .font(.headline)
                        .padding(.leading)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) { // Ajustar el espacio entre las tarjetas
                            ForEach(viewModel.obtenerDocumentosUsuario().filter { searchQuery.isEmpty || $0.nombreDocumento.localizedCaseInsensitiveContains(searchQuery) }) { documento in
                                NavigationLink(destination: DocumentDetailView(documento: documento)) {
                                    VStack {
                                        // Icono del documento
                                        ZStack {
                                            Rectangle() // El contenedor de la imagen
                                                .frame(width: imageWidth + 30, height: imageHeight) // Tamaño más pequeño para la imagen
                                                .foregroundColor(.white) // Fondo blanco
                                                .cornerRadius(8) // Bordes redondeados
                                                .shadow(radius: 2) // Sombra ligera
                                            
                                            Image(systemName: "doc.text")
                                                .resizable()
                                                .frame(width: imageWidth, height: imageHeight)
                                        }

                                        // Título del documento
                                        Text(documento.nombreDocumento)
                                            .font(.caption)
                                            .lineLimit(1) // Limitar a 1 líneas
                                            .truncationMode(.tail) // Mostrar puntos suspensivos si el texto es largo
                                            .multilineTextAlignment(.center)
                                            .foregroundColor(.black) // Texto en color negro
                                            .frame(width: 80)

                                        // Autor del documento
                                        Text("Autor desconocido")
                                            .font(.caption2)
                                            .lineLimit(1) // Limitar a 1 línea
                                            .truncationMode(.tail) // Mostrar puntos suspensivos si el texto es largo
                                            .foregroundColor(.gray) // Texto en color gris
                                            .frame(width: 80)
                                    }
                                    .background(Color.white) // Fondo blanco para la tarjeta
                                    .cornerRadius(12) // Bordes redondeados para la tarjeta
                                    .shadow(radius: 2) // Sombra ligera
                                    .frame(width: cardWidth, height: containerHeight) // Tamaño total del contenedor más pequeño
                                    .padding(.leading, 0)
                                }
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)                .background(Color(.systemGray6)) // Fondo claro para todo
            }
            .edgesIgnoringSafeArea(.bottom)
            .background(Color(.systemGray6))
            .navigationTitle("Biblioteca Legal")
        }
    }
}

#Preview {
    BibliotecaView()
}
