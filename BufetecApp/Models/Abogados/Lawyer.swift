import Foundation

struct Lawyer: Identifiable, Codable {
    let id: String
    let userId: String
    let nombre: String
    let especializacion: String
    let experienciaProfesional: String
    let disponibilidad: Bool
    let maestria: String
    let direccion: Direccion
    let casosAsignados: [String]
    let telefono: String
    let correo: String
    let casosAtendidos: Int
    let casosSentenciaFavorable: Int
    let imageName: String
    
    struct Direccion: Codable {
        let calle: String
        let ciudad: String
        let estado: String
        let codigo_postal: String
    }
}
