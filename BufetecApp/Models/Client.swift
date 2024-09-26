import SwiftUI

struct Client: Identifiable, Codable {
    var id = UUID()
    var user_id: String
    var nombre: String
    var direccion: Direccion
    var telefono: String
    var correo: String
    var casos_asociados: [String]
    var status: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case user_id
        case nombre
        case direccion
        case telefono
        case correo
        case casos_asociados
        case status
    }
    
    init(id: UUID = UUID(), user_id: String, nombre: String, direccion: Direccion, telefono: String, correo: String, casos_asociados: [String], status: String) {
        self.id = id
        self.user_id = user_id
        self.nombre = nombre
        self.direccion = direccion
        self.telefono = telefono
        self.correo = correo
        self.casos_asociados = casos_asociados
        self.status = status
    }
}

struct Direccion: Codable {
    var calle: String
    var ciudad: String
    var estado: String
    var codigo_postal: String
    
    enum CodingKeys: String, CodingKey {
        case calle
        case ciudad
        case estado
        case codigo_postal
    }
}
