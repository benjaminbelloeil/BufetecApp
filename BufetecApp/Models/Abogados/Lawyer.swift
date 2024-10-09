import Foundation

struct Lawyer: Identifiable, Codable {
    let id: String  // Keep as String since JSON provides a string
    let userId: String?
    let nombre: String
    let especializacion: String
    let experienciaProfesional: String
    let disponibilidad: Bool?  // Change to optional Bool to handle empty strings
    let maestria: String?
    let direccion: Direccion
    let casosAsignados: [String]?  // Optional to handle empty arrays or empty strings
    let telefono: String
    let correo: String
    let casosAtendidos: Int  // Optional Int to handle empty strings
    let casosSentenciaFavorable: Int  // Optional Int to handle empty strings
    let imageName: String

    struct Direccion: Codable {
        let calle: String
        let ciudad: String
        let estado: String
        let codigo_postal: String
    }

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "userId"
        case nombre
        case especializacion
        case experienciaProfesional = "experiencia_profesional"  // Map to snake_case
        case disponibilidad
        case maestria
        case direccion
        case casosAsignados = "casos_asignados"  // Map to snake_case
        case telefono
        case correo
        case casosAtendidos = "casos_atendidos"  // Map to snake_case
        case casosSentenciaFavorable = "casos_con_sentencia_a_favor"  // Map to snake_case
        case imageName = "url_recurso"
    }
}

