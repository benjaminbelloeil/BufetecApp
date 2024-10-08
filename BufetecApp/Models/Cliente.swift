
import SwiftUI

struct Cliente: Identifiable {
    let id = UUID()
    let user_id: String
    let nombre: String
    let contacto: String
    let proxima_audiencia: Date
    let telefono: String
    let correo: String
    let fecha_inicio: Date
    let direccion: Direccion
    let imageName: String
    
    struct Direccion: Codable {
        let calle: String
        let ciudad: String
        let estado: String
        let codigo_postal: String
    }
    
}
