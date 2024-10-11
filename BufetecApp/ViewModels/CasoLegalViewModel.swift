//
//  CasoLegalViewModel.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/21/24.
//

import Foundation
import SwiftUI

class CasoLegalViewModel: ObservableObject {
    @Published var casos: [CasoLegal] = []
    @Published var selectedCaso: CasoLegal? // Para manejar el caso seleccionado

    // Cargar casos desde un servicio o base de datos
    func loadCasos() {
        // Ejemplo de datos ficticios
        casos = [
                    CasoLegal(
                        id: "1",
                        nombre_caso: "Pvp",
                        numero_expediente: "1",
                        cliente_id: "1",
                        abogado_id: "1",
                        tipo_proceso: "Divorcio",
                        estado_proceso: "Activo",
                        prioridad: "Alta",
                        fechaInicio: Date(),
                        fecha_fin: Date(),
                        documentos: [CasoLegal.Documento(nombre: "Juan", url: "heh.pdf")],
                        responsable: ["Juan", "Paco"]
                    ),
                    CasoLegal(
                        id: "2",
                        nombre_caso: "Caso de Ejemplo",
                        numero_expediente: "2",
                        cliente_id: "2",
                        abogado_id: "2",
                        tipo_proceso: "Civil",
                        estado_proceso: "En Proceso",
                        prioridad: "Media",
                        fechaInicio: Date(),
                        fecha_fin: nil,
                        documentos: [CasoLegal.Documento(nombre: "Paco", url: "doc.pdf")],
                        responsable: ["Ana", "Luis"]
                    )
                    // Otros casos...
                ]
    }
    
    func filteredCasos(searchText: String) -> [CasoLegal] {
        if searchText.isEmpty {
            return casos
        } else {
            return casos.filter { $0.nombre_caso.lowercased().contains(searchText.lowercased()) }
        }
    }

    func addCaso(_ caso: CasoLegal) {
        casos.append(caso)
    }

    func removeCaso(_ caso: CasoLegal) {
        if let index = casos.firstIndex(where: { $0.id == caso.id }) {
            casos.remove(at: index)
        }
    }

    func updateCaso(_ caso: CasoLegal) {
        if let index = casos.firstIndex(where: { $0.id == caso.id }) {
            casos[index] = caso
        }
    }
}
