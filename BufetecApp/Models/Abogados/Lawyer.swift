//
//  Lawyer.swift
//  BufetecApp
//
//  Created by Antonio Gutierrez on 22/09/24.
//

import Foundation
struct Lawyer: Identifiable{
    var id = UUID()
    var name: String
    var specialty: String
    var caseType: String
    var imageName: String
}
