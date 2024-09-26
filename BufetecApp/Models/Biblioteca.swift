//
//  Biblioteca.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

struct Biblioteca: Identifiable, Codable {
    var id: String
    var titulo: String
    var descripcion: String
    var tipoRecurso: String
    var categoria: String
    var autor: String
    var fechaCreacion: Date
    var urlRecurso: String
    var portada: String
    var status: String
    
    init(id: String, titulo: String, descripcion: String, tipoRecurso: String, categoria: String, autor: String, fechaCreacion: Date, urlRecurso: String, portada: String, status: String) {
        self.id = id
        self.titulo = titulo
        self.descripcion = descripcion
        self.tipoRecurso = tipoRecurso
        self.categoria = categoria
        self.autor = autor
        self.fechaCreacion = fechaCreacion
        self.urlRecurso = urlRecurso
        self.portada = portada
        self.status = status
    }

    // Definir CodingKeys para que coincidan con las claves del JSON
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case titulo = "titulo"
        case descripcion = "descripcion"
        case tipoRecurso = "tipoRecurso"
        case categoria = "categoria"
        case autor = "autor"
        case fechaCreacion = "fechaCreacion"
        case urlRecurso = "urlRecurso"
        case portada = "portada"
        case status = "status"
    }

    // Decodificación personalizada para manejar la fecha
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        titulo = try container.decode(String.self, forKey: .titulo)
        descripcion = try container.decode(String.self, forKey: .descripcion)
        tipoRecurso = try container.decode(String.self, forKey: .tipoRecurso)
        categoria = try container.decode(String.self, forKey: .categoria)
        autor = try container.decode(String.self, forKey: .autor)
        urlRecurso = try container.decode(String.self, forKey: .urlRecurso)
        portada = try container.decode(String.self, forKey: .portada)
        status = try container.decode(String.self, forKey: .status)

        // Usamos una estrategia de decodificación de fecha personalizada
        let fechaString = try container.decode(String.self, forKey: .fechaCreacion)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        if let fecha = formatter.date(from: fechaString) {
            fechaCreacion = fecha
        } else {
            throw DecodingError.dataCorruptedError(forKey: .fechaCreacion,
                                                   in: container,
                                                   debugDescription: "Formato de fecha no coincide")
        }
    }

    // Codificación personalizada (si es necesario)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(titulo, forKey: .titulo)
        try container.encode(descripcion, forKey: .descripcion)
        try container.encode(tipoRecurso, forKey: .tipoRecurso)
        try container.encode(categoria, forKey: .categoria)
        try container.encode(autor, forKey: .autor)
        try container.encode(urlRecurso, forKey: .urlRecurso)
        try container.encode(portada, forKey: .portada)
        try container.encode(status, forKey: .status)

        // Codificamos la fecha como string
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        let fechaString = formatter.string(from: fechaCreacion)
        try container.encode(fechaString, forKey: .fechaCreacion)
    }
}
