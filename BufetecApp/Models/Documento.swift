//
//  Documento.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

struct Documento: Identifiable, Codable {
    var id: String
    var casoId: String
    var userId: String  // Nuevo campo agregado
    var nombreDocumento: String
    var tipoDocumento: String
    var urlDocumento: String
    var status: String
    var createdAt: Date

    // Inicializador adicional para usarlo en tus previews
    init(id: String, casoId: String, userId: String, nombreDocumento: String, tipoDocumento: String, urlDocumento: String, status: String, createdAt: Date) {
        self.id = id
        self.casoId = casoId
        self.userId = userId
        self.nombreDocumento = nombreDocumento
        self.tipoDocumento = tipoDocumento
        self.urlDocumento = urlDocumento
        self.status = status
        self.createdAt = createdAt
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case casoId
        case userId
        case nombreDocumento
        case tipoDocumento
        case urlDocumento
        case status
        case createdAt
    }

    // Decodificación personalizada para manejar la fecha
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        casoId = try container.decode(String.self, forKey: .casoId)
        userId = try container.decode(String.self, forKey: .userId)  // Nuevo campo decodificado
        nombreDocumento = try container.decode(String.self, forKey: .nombreDocumento)
        tipoDocumento = try container.decode(String.self, forKey: .tipoDocumento)
        urlDocumento = try container.decode(String.self, forKey: .urlDocumento)
        status = try container.decode(String.self, forKey: .status)

        // Usamos una estrategia de decodificación de fecha personalizada
        let createdAtString = try container.decode(String.self, forKey: .createdAt)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"  // Cambia el formato según sea necesario
        if let createdAtDate = formatter.date(from: createdAtString) {
            createdAt = createdAtDate
        } else {
            throw DecodingError.dataCorruptedError(forKey: .createdAt,
                                                   in: container,
                                                   debugDescription: "Formato de fecha no coincide")
        }
    }

    // Codificación personalizada (si es necesario)
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(casoId, forKey: .casoId)
        try container.encode(userId, forKey: .userId)  // Nuevo campo codificado
        try container.encode(nombreDocumento, forKey: .nombreDocumento)
        try container.encode(tipoDocumento, forKey: .tipoDocumento)
        try container.encode(urlDocumento, forKey: .urlDocumento)
        try container.encode(status, forKey: .status)

        // Codificamos la fecha como string
        let formatter = DateFormatter()
        formatter.dateFormat = "E, dd MMM yyyy HH:mm:ss z"
        let createdAtString = formatter.string(from: createdAt)
        try container.encode(createdAtString, forKey: .createdAt)
    }
}
