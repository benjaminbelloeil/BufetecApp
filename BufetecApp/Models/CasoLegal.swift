import SwiftUI

struct CasoLegal: Identifiable, Codable {
    var id: String
    var nombre_caso: String
    var numero_expediente: String
    var cliente_id: String
    var abogado_id: String
    var tipo_proceso: String
    var estado_proceso: String
    var prioridad: String
    var fechaInicio: Date?
    var fecha_fin: Date?
    var documentos: [Documento]
    var responsable: [String]


 struct Documento: Codable {
        var nombre: String
        var url: String
    }

    init(id: String, nombre_caso: String, numero_expediente: String, cliente_id: String, abogado_id: String, tipo_proceso: String, estado_proceso: String, prioridad: String, fechaInicio: Date?, fecha_fin: Date?, documentos: [Documento], responsable: [String]) {
        self.id = id
        self.nombre_caso = nombre_caso
        self.numero_expediente = numero_expediente
        self.cliente_id = cliente_id
        self.abogado_id = abogado_id
        self.tipo_proceso = tipo_proceso
        self.estado_proceso = estado_proceso
        self.prioridad = prioridad
        self.fechaInicio = fechaInicio
        self.fecha_fin = fecha_fin
        self.documentos = documentos
        self.responsable = responsable
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case nombre_caso = "nombre_caso"
        case numero_expediente = "numero_expediente"
        case cliente_id = "cliente_id"
        case abogado_id = "abogado_id"
        case tipo_proceso = "tipo_proceso"
        case estado_proceso = "estado_proceso"
        case prioridad = "prioridad"
        case fechaInicio = "fechaInicio"
        case fecha_fin = "fecha_fin"
        case documentos = "documentos"
        case responsable = "responsable"
    }
}
