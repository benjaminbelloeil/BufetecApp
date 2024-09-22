//
//  CasoLegal.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//
import Foundation

struct CasoLegal: Identifiable {
    var id = UUID()
    var nombre: String
    var expediente: String
    var parteActora: String
    var parteDemandada: String
    var estado: String
    var perfilCliente: String
    var notas: String
}
