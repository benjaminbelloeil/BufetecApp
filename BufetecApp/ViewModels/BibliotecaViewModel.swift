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
            Biblioteca(id: "66f1ccdd273de98e8013e4d3", titulo: "Guía sobre derecho civil", descripcion: "Este documento da una guia facil al derecho civil", tipoRecurso: "Artículo", categoria: "Derecho", autor: "Carlos Martínez", fechaCreacion: Date(), urlRecurso: "https://mi_servidor/videos/guia_derecho_civil.mp4", portada: "https://www.unamenlinea.unam.mx/recursos/img/82853/guia-de-estudio-del-derecho-procesal-civil.jpg", status: "Activo"),
                Biblioteca(id: "66f451656a77632a3aee1d55", titulo: "Divorcio", descripcion: "Divorcio", tipoRecurso: "Libro", categoria: "Divorcio", autor: "Silva Meza, Juan N.", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris1/adam/objects/scj50/view/4/Divorcio_Incausado_000115653.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris1/adam/objects/scj50/thumbnail/4/292060_000115656.jpg", status: "Activo"),
                Biblioteca(id: "66f4540d6a77632a3aee1d59", titulo: "Matrimonio y divorcio", descripcion: "Este libro habla de matrimonio y divorcio", tipoRecurso: "Libro", categoria: "Divorcio", autor: "Pinkus Aguilar, María Fernanda", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/EB4USN7APUI6SNTDE4N1QVSMJ6AGXN.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/HX415TJCQACA79B5D2C3C6LY372JN6T1RA4.jpg", status: "Activo"),
                Biblioteca(id: "66f453b7b28d2a9bf5e6a5fc", titulo: "Derecho a la seguridad social: pensión por ascendencia y orfandad", descripcion: "Pensiones", tipoRecurso: "Libro", categoria: "Pensiones", autor: "González Carvallo, Diana Beatriz", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/FA6RRD25YNLIP469ETL8JMT2HAAEI4.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/FA6RRD25YNLIP469ETL8JMT2HAAEI4.pdf", status: "Activo"),
                Biblioteca(id: "66f4548cb28d2a9bf5e6a5fd", titulo: "Derecho a la seguridad social: pensión por viudez en el concubinato", descripcion: "Libro de pensiones", tipoRecurso: "Libro", categoria: "Pensiones", autor: "Silva Meza, Juan N.", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/9R87E7T6B7CT4VM5NJSMDSAC859QIV.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/IEAQYHBPHSYKKFCGEIDRIJEN1VF4I1B1ELA.jpg", status: "Activo"),
                Biblioteca(id: "66f455546a77632a3aee1d5a", titulo: "Aspectos patrimoniales del matrimonio", descripcion: "Este libro habla de matrimonio y divorcio", tipoRecurso: "Libro", categoria: "Divorcio", autor: "González Carvallo, Diana Beatriz", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/8PU6GJRLQJU11RKJS59VVKED3NA1E8.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/9VERA9RVQPIQDGICDKP4PHHUMEXG8N4SFXY.jpg", status: "Activo"),
                Biblioteca(id: "66f455d1b28d2a9bf5e6a600", titulo: "Derecho a la seguridad social: pensión por viudez en el matrimonio", descripcion: "Libro de pensiones alimenticias", tipoRecurso: "Liro", categoria: "Pensiones", autor: "González Carvallo, Diana Beatriz", fechaCreacion: Date(), urlRecurso: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/SMNLY9VN9HJECN4HMUYITKUJVKRGVL.pdf", portada: "https://sistemabibliotecario.scjn.gob.mx/exlibris/aleph/a23_1/apache_media/37V4A7794E6ULXHLJ42R87A8BNLUFFS8VA7.jpg", status: "Activo")
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
