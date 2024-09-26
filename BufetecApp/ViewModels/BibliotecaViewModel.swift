//
//  BibliotecaViewModel.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

class BibliotecaViewModel: ObservableObject {
    
    @Published var bibliotecas: [Biblioteca] = []
    @Published var documentos: [Documento] = []
    @Published var chats: [Chat] = []
    
    let urlPrefix = "http://localhost:5001/"
    
    init() {
        Task {
            await fetchBibliotecas()
            await fetchDocumentos()
            await fetchChats()
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
            print("Failed to fetch bibliotecas")
        }
    }

    // Fetch de documentos
    func fetchDocumentos() async {
//        let userId = "current_user_id"  Reemplaza esto con el ID de usuario correcto
//        let url = URL(string: "\(urlPrefix)documentos/\(userId)")!
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
            print("Failed to fetch documentos")
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
            print("Failed to fetch chats")
        }
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
