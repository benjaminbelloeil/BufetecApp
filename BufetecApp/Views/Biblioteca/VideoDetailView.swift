import SwiftUI

struct VideoDetailView: View {
    let video: Video
    @State private var isDescriptionExpanded = false
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Video player
                YouTubeView(videoID: video.videoID)
                    .frame(height: 220)
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    .padding(.bottom, 10)
                
                // Video information
                VStack(alignment: .leading, spacing: 12) {
                    Text(video.titulo)
                        .font(.title2)
                        .fontWeight(.bold)
                        .lineLimit(2)
                    
                    HStack {
                        Label(video.duracion, systemImage: "clock")
                        Spacer()
                        Label("Derecho Civil", systemImage: "book.closed")
                    }
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                
                // Description
                VStack(alignment: .leading, spacing: 10) {
                    Text("Descripción")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Text(video.descripcion)
                        .font(.body)
                        .foregroundColor(.secondary)
                        .lineLimit(isDescriptionExpanded ? nil : 3)
                        .padding(.horizontal)
                    
                    Button(action: {
                        withAnimation {
                            isDescriptionExpanded.toggle()
                        }
                    }) {
                        Text(isDescriptionExpanded ? "Leer menos" : "Leer más")
                            .font(.subheadline)
                            .foregroundColor(.blue)
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 10)
                .background(colorScheme == .dark ? Color.black.opacity(0.3) : Color.gray.opacity(0.1))
                .cornerRadius(12)
                
                // Related videos
                VStack(alignment: .leading, spacing: 10) {
                    Text("Videos relacionados")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 15) {
                            ForEach(1...4, id: \.self) { _ in
                                RelatedVideoCard()
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.top)
            }
            .padding(.vertical)
        }
        .navigationTitle("Video Educativo")
        .navigationBarTitleDisplayMode(.inline)
        .background(colorScheme == .dark ? Color.black : Color.white)
    }
}

struct RelatedVideoCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Image("placeholder")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 160, height: 90)
                .cornerRadius(10)
            
            Text("Título del video relacionado")
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(2)
            
            Text("2:30")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(width: 160)
    }
}

struct VideoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            VideoDetailView(video: Video(
                id: UUID(),
                titulo: "Introducción al Derecho Civil: Conceptos Fundamentales y Aplicaciones Prácticas",
                descripcion: "Este video ofrece una introducción completa al Derecho Civil en España. Exploraremos los conceptos fundamentales que forman la base de este campo legal, incluyendo los derechos y obligaciones de los individuos, la propiedad, los contratos y la responsabilidad civil. A través de ejemplos prácticos y casos de estudio, ilustraremos cómo estos principios se aplican en situaciones cotidianas y en el sistema legal español. Ya seas estudiante de derecho, profesional en formación o simplemente alguien interesado en comprender mejor tus derechos legales, este video te proporcionará una base sólida en los principios del Derecho Civil.",
                thumbnailURL: "https://example.com/thumbnail1.jpg",
                videoID: "8SYMMKsSFPos",
                duracion: "15:30"))
        }
    }
}
