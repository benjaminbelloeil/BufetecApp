import SwiftUI
struct Lawyer: Identifiable, Codable{
    var id = UUID()
    var user_id : String
    var nombre: String
    var especialidad: String
    var experiencia_profesional: String
    var disponibilidad: Bool
    var maestria: String
    var direccion : Direccion
    var telefono: String
    var correo : String
    var casos_atendidos:Int
    var casos_con_setencia_a_favor: Int
    var casos_asignados: [String]
    var imageName: String
    
}

struct Direccion : Codable{
    var calle: String
    var ciudad : String
    var estado : String
    var codigo_postal: String
    
}
