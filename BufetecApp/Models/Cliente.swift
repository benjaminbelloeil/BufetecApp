import Foundation

struct Cliente: Identifiable, Codable {
    var id: String
    var nombre: String
    var contacto: String
    var proxima_audiencia: Date?
    var telefono: String
    var correo: String
    var fecha_inicio: Date?
    var direccion: Direccion
    var imageName: String
    var disponibilidad: Bool

    struct Direccion: Codable {
        var calle: String
        var ciudad: String
        var estado: String
        var codigo_postal: String
    }

    enum CodingKeys: String, CodingKey {
        case id
        case nombre
        case contacto
        case proxima_audiencia
        case telefono
        case correo
        case fecha_inicio
        case direccion
        case imageName = "url_recurso"
        case disponibilidad
    }
}