import Foundation

class BibliotecaViewModel: ObservableObject {
    
    @Published var bibliotecas: [Biblioteca] = []
    @Published var documentos: [Documento] = []
    @Published var chats: [Chat] = []
    @Published var videos: [Video] = []  // Los videos se definen directamente aquí

    let urlPrefix = "http://10.14.255.54:5001/"
    
    init() {
        Task {
            await fetchBibliotecas()
            await fetchDocumentos()
            await fetchChats()
            loadStaticVideos()  // Cargar los videos directamente
        }
    }
    
    // Fetch de bibliotecas
    func fetchBibliotecas() async {
        let url = URL(string: "\(urlPrefix)biblioteca")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Biblioteca].self, from: data) {
                bibliotecas = decodedResponse
            }
        } catch {
            print("Failed to fetch bibliotecas: \(error.localizedDescription)")
        }
    }

    // Fetch de documentos
    func fetchDocumentos() async {
        let url = URL(string: "\(urlPrefix)documentos")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            if let decodedResponse = try? JSONDecoder().decode([Documento].self, from: data) {
                documentos = decodedResponse
            }
        } catch {
            print("Failed to fetch documentos: \(error.localizedDescription)")
        }
    }
    
    // Fetch de chats
    func fetchChats() async {
        let userId = "current_user_id" // Reemplaza esto con el ID de usuario correcto
        let url = URL(string: "\(urlPrefix)chats/\(userId)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Chat].self, from: data) {
                chats = decodedResponse
            }
        } catch {
            print("Failed to fetch chats: \(error.localizedDescription)")
        }
    }

    // Cargar videos estáticos o de YouTube
    func loadStaticVideos() {
        videos = [
            Video(
                id: UUID(),
                titulo: "Juicio de Convivencia: Aspectos Legales y Procedimientos",
                descripcion: "Este video explica en detalle los fundamentos del juicio de convivencia, incluyendo los derechos y obligaciones de las partes involucradas. Se aborda cómo se garantiza el bienestar de los menores y qué criterios se siguen para establecer acuerdos de convivencia entre los padres.",
                thumbnailURL: "https://example.com/thumb1.jpg",
                videoID: "r8Ro0gUhqCA",  // ID del video de YouTube
                duracion: "7:18"
            ),
            Video(
                id: UUID(),
                titulo: "Juicio Oral: Procedimiento y Derechos de las Partes",
                descripcion: "Una explicación completa sobre el juicio oral, uno de los procedimientos más importantes en el sistema judicial. En este video se detallan las fases del juicio, los derechos de las partes, y la relevancia de la oralidad en la administración de justicia.",
                thumbnailURL: "https://example.com/thumb2.jpg",
                videoID: "8SYMMKsSFPo",  // ID del video de YouTube
                duracion: "7:20"
            ),
            Video(
                id: UUID(),
                titulo: "Divorcio: Proceso Legal y Consecuencias",
                descripcion: "Este video aborda el proceso legal del divorcio, explicando las etapas clave, los derechos de ambas partes, y las implicaciones tanto emocionales como financieras que conlleva. También se trata la importancia de los acuerdos sobre los bienes y la custodia de los hijos.",
                thumbnailURL: "https://example.com/thumb3.jpg",
                videoID: "YH_fRwHabZ0",  // ID del video de YouTube (short)
                duracion: "7:27"
            ),
            Video(
                id: UUID(),
                titulo: "Rectificación de Actas: Cómo Corregir Errores en Documentos Legales",
                descripcion: "En este video se explica el proceso para rectificar actas oficiales, como actas de nacimiento, matrimonio o defunción. Se detallan los pasos legales para corregir errores en estos documentos, y se describen los documentos necesarios y el tiempo que toma el proceso.",
                thumbnailURL: "https://example.com/thumb4.jpg",
                videoID: "8VM0mVPoHEI",  // ID del video de YouTube (short)
                duracion: "7:29"
            )
        ]
    }
    // Función para obtener documentos de los chats del usuario (Continuar explorando)
    func obtenerDocumentosDeChats() -> [Documento] {
        let documentIds = chats.map { $0.documentId }
        return documentos.filter { documentIds.contains($0.id) }
    }
    
    // Función para obtener sugerencias de documentos basados en el tipo de proceso (Para ti)
    func obtenerSugerencias(tipoProceso: String) -> [Biblioteca] {
        print(bibliotecas)
        return bibliotecas.filter { $0.categoria == tipoProceso }
    }
    
    // Función para obtener los documentos del usuario (Tus documentos)
    func obtenerDocumentosUsuario() -> [Documento] {
        return documentos
    }

    // Función para obtener los videos educativos
    func obtenerVideosEducativos() -> [Video] {
        return videos
    }

    // Función para eliminar un documento
    func deleteDocumento(documento: Documento) async {
        let url = URL(string: "\(urlPrefix)documento/\(documento.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Eliminar localmente
            documentos.removeAll { $0.id == documento.id }
        } catch {
            print("Failed to delete document")
        }
    }

    // Función para agregar un documento
    func addDocumento(documento: Documento) async {
        let url = URL(string: "\(urlPrefix)documento")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(documento) {
            request.httpBody = encoded
        }
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Manejar éxito, por ejemplo, agregar el documento localmente
            documentos.append(documento)
        } catch {
            print("Failed to add document")
        }
    }

    // Función para actualizar un documento
    func updateDocumento(documento: Documento) async {
        let url = URL(string: "\(urlPrefix)documento/\(documento.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(documento) {
            request.httpBody = encoded
        }
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Manejar éxito, por ejemplo, actualizar el documento localmente
            if let index = documentos.firstIndex(where: { $0.id == documento.id }) {
                documentos[index] = documento
            }
        } catch {
            print("Failed to update document")
        }
    }
}
