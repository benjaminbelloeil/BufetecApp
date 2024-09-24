//
//  Biblioteca.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

struct Biblioteca: Identifiable {
    var id: String
    var titulo: String
    var tipoRecurso: String
    var categoria: String
    var autor: String
    var fechaCreacion: Date
    var urlRecurso: String
    var status: String
}
