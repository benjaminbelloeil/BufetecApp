//
//  Documento.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

struct Documento: Identifiable {
    var id: String
    var casoId: String
    var nombreDocumento: String
    var tipoDocumento: String
    var urlDocumento: String
    var status: String
    var createdAt: Date
}
