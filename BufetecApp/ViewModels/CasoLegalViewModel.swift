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
            CasoLegal(idCliente: UUID(), idAbogado: UUID(), nombre: "Caso Ejemplo 1", expediente: "111111", parteActora: "Parte Actora 1", parteDemandada: "Parte Demandada 1", estado: "Activo", notas: "Notas adicionales aquí."),
            CasoLegal(idCliente: UUID(), idAbogado: UUID(), nombre: "Caso Ejemplo 2", expediente: "222222", parteActora: "Parte Actora 2", parteDemandada: "Parte Demandada 2", estado: "En Proceso", notas: "Notas adicionales aquí."),
            // Otros casos...
        ]
    }
    
    func filteredCasos(searchText: String) -> [CasoLegal] {
        if searchText.isEmpty {
            return casos
        } else {
            return casos.filter { $0.nombre.lowercased().contains(searchText.lowercased()) }
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
