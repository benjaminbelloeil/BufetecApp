import Foundation

struct Lawyer: Identifiable, Codable {
    var id = UUID()
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
    
    init(userId: String, nombre: String, especializacion: String, experienciaProfesional: String, disponibilidad: Bool, maestria: String, direccion: Direccion, casosAsignados: [String], telefono: String, correo: String, casosAtendidos: Int, casosSentenciaFavorable: Int, imageName: String) {
        self.userId = userId
        self.nombre = nombre
        self.especializacion = especializacion
        self.experienciaProfesional = experienciaProfesional
        self.disponibilidad = disponibilidad
        self.maestria = maestria
        self.direccion = direccion
        self.casosAsignados = casosAsignados
        self.telefono = telefono
        self.correo = correo
        self.casosAtendidos = casosAtendidos
        self.casosSentenciaFavorable = casosSentenciaFavorable
        self.imageName = imageName
    }
}
