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
    // Datos de documentos
    @Published var documentos: [Documento] = []
    
    // Datos dummy (estos serán reemplazados cuando se haga el fetch desde la API)
    init() {
        // Datos dummy para la biblioteca
        bibliotecas = [
            Biblioteca(id: "1", titulo: "Guía sobre derecho civil", tipoRecurso: "Artículo", categoria: "Recursos Educativos", autor: "Carlos Martínez", fechaCreacion: Date(), urlRecurso: "https://mi_servidor/videos/guia_derecho_civil.mp4", status: "Activo"),
            Biblioteca(id: "2", titulo: "Matrimonio y divorcio", tipoRecurso: "Libro", categoria: "Derecho Familiar", autor: "María Pinkus", fechaCreacion: Date(), urlRecurso: "https://mi_servidor/videos/matrimonio_divorcio.pdf", status: "Activo")
        ]
        
        // Datos dummy para los documentos
        documentos = [
            Documento(id: "1", casoId: "123", nombreDocumento: "Sentencia de divorcio", tipoDocumento: "Sentencia", urlDocumento: "https://mi_servidor/documentos/sentencia.pdf", status: "Activo", createdAt: Date()),
            Documento(id: "2", casoId: "124", nombreDocumento: "Acta de matrimonio", tipoDocumento: "Acta", urlDocumento: "https://mi_servidor/documentos/acta_matrimonio.pdf", status: "Activo", createdAt: Date())
        ]
    }
    
    // Preparar para hacer el fetch de la API Flask
    func fetchBibliotecas() {
        // Aquí se hará el llamado a la API Flask para obtener los datos reales
    }
    
    func fetchDocumentos() {
        // Aquí se hará el llamado a la API Flask para obtener los documentos reales
    }
}
