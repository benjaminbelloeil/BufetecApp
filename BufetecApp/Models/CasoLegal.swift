import SwiftUI

struct CasoLegal: Identifiable, Codable {
    var id: String
    var idCliente: String?
    var idAbogado: String?
    var nombre: String
    var expediente: String
    var parteActora: String?
    var parteDemandada: String?
    var estado: String
    var notas: String
    var proximaAudiencia: Date?
    var fechaInicio: Date?
    var imageName: String?

    init(id: String, idCliente: String?, idAbogado: String?, nombre: String, expediente: String, parteActora: String, parteDemandada: String, estado: String, notas: String, proximaAudiencia: Date, fechaInicio: Date, imageName: String) {
        self.id = id
        self.idCliente = idCliente
        self.idAbogado = idAbogado
        self.nombre = nombre
        self.expediente = expediente
        self.parteActora = parteActora
        self.parteDemandada = parteDemandada
        self.estado = estado
        self.notas = notas
        self.proximaAudiencia = proximaAudiencia
        self.fechaInicio = fechaInicio
        self.imageName = imageName
    }

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case idCliente = "cliende_id"
        case idAbogado = "abogado_id"
        case nombre = "tipo_proceso"
        case expediente = "expediente"
        case parteActora = "parte_actora"
        case parteDemandada = "parte_demandada"
        case estado = "estado_proceso"
        case notas = "notas"
        case proximaAudiencia = "proxima_audiencia"
        case fechaInicio = "fecha_inicio"
        case imageName = "url_recurso"
    }
}
