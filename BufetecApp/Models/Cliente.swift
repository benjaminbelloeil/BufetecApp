import SwiftUI

struct Cliente: Identifiable, Codable {
    var id: String
    var user_id: String?
    var nombre: String
    var contacto: String
    var proxima_audiencia: Date
    var telefono: String
    var correo: String
    var fecha_inicio: Date
    var direccion: Direccion
    var imageName: String

    init(id: String, user_id: String, nombre: String, contacto: String, proxima_audiencia: Date, telefono: String, correo: String, fecha_inicio: Date, direccion: Direccion, imageName: String) {
        self.id = id
        self.user_id = user_id
        self.nombre = nombre
        self.contacto = contacto
        self.proxima_audiencia = proxima_audiencia
        self.telefono = telefono
        self.correo = correo
        self.fecha_inicio = fecha_inicio
        self.direccion = direccion
        self.imageName = imageName
    }

    struct Direccion: Codable {
        var calle: String
        var ciudad: String
        var estado: String
        var codigo_postal: String
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case user_id = "user_id"
        case nombre = "nombre"
        case contacto = "contacto"
        case proxima_audiencia = "proxima_audiencia"
        case telefono = "telefono"
        case correo = "correo"
        case fecha_inicio = "fecha_inicio"
        case direccion = "direccion"
        case imageName = "url_recurso"
    }
}