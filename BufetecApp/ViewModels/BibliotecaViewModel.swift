//
//  BibliotecaViewModel.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

class BibliotecaViewModel: ObservableObject {
    // Datos de la biblioteca
    @Published var bibliotecas: [Biblioteca] = []
    // Datos de documentos del usuario
    @Published var documentos: [Documento] = []
    // Datos de chats asociados al usuario
    @Published var chats: [Chat] = []

    init() {
        // Datos dummy para la biblioteca
        bibliotecas = [
            Biblioteca(id: "1", titulo: "Guía sobre derecho civil", descripcion: "Libro para darte una idea del derecho civil", tipoRecurso: "Artículo", categoria: "Recursos Educativos", autor: "Carlos Martínez", fechaCreacion: Date(), urlRecurso: "https://mi_servidor/videos/guia_derecho_civil.mp4", status: "Activo"),
            Biblioteca(id: "2", titulo: "Matrimonio y divorcio", descripcion: "Libro para que aprendas como divociarte", tipoRecurso: "Libro", categoria: "Derecho Familiar", autor: "María Pinkus", fechaCreacion: Date(), urlRecurso: "https://mi_servidor/videos/matrimonio_divorcio.pdf", status: "Activo")
        ]
        
        documentos = [
            Documento(id: "1", casoId: "123", nombreDocumento: "Sentencia de divorcio", tipoDocumento: "Sentencia", urlDocumento: "https://mi_servidor/documentos/sentencia.pdf", status: "Activo", createdAt: Date()),
            Documento(id: "2", casoId: "124", nombreDocumento: "Acta de matrimonio", tipoDocumento: "Acta", urlDocumento: "https://mi_servidor/documentos/acta_matrimonio.pdf", status: "Activo", createdAt: Date())
        ]
        
        // Datos dummy para los chats
        chats = [
            Chat(id: "1", chatId: "111", userId: "1", documentId: "1", assistantId: "999", messages: [
                Message(sender: "user", message: "Hola, ¿cómo puedo ayudarte hoy?", timestamp: Date()),
                Message(sender: "assistant", message: "Estoy aquí para ayudarte con tus dudas legales.", timestamp: Date())
            ])
        ]
    }

    // Función para obtener documentos de los chats del usuario (Continuar explorando)
    func obtenerDocumentosDeChats() -> [Documento] {
        let documentIds = chats.map { $0.documentId }
        return documentos.filter { documentIds.contains($0.id) }
    }
    
    // Función para obtener sugerencias de documentos basados en el tipo de proceso (Para ti)
    func obtenerSugerencias(tipoProceso: String) -> [Biblioteca] {
        return bibliotecas.filter { $0.categoria == tipoProceso }
    }
    
    // Función para obtener los documentos del usuario (Tus documentos)
    func obtenerDocumentosUsuario() -> [Documento] {
        return documentos
    }

    // Aquí haremos el fetch real cuando la API esté lista
    // func fetchBibliotecas() { }
    // func fetchDocumentos() { }
}
