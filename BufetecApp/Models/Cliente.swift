
import SwiftUI

struct Cliente: Identifiable {
    let id = UUID()
    let name: String
    let caseType: String
    let status: String
    
    var statusColor: Color {
        switch status {
        case "Activo":
            return .green
        case "En espera":
            return .orange
        case "Cerrado":
            return .red
        default:
            return .gray
        }
    }
}
