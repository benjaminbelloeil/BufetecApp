import SwiftUI
struct Client: Identifiable, Codable{
    var id = UUID()
    var user_id : String
    var nombre: String
    var direccion : Direccion
    var telefono: String
    var correo : String
    var casos_asociados: [String]
    var status: String
    
}

struct Direccion : Codable{
    var calle: String
    var ciudad : String
    var estado : String
    var codigo_postal: String
    
}


