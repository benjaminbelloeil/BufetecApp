import SwiftUI

struct CaseDetailView: View {
    @State private var selectedCase: Case?
    @State private var isPresentingNewCaseView = false
    @State private var searchText = ""
    
    let cases: [Case] = [
        Case(id: 1, name: "Divorcio García", clientName: "Ana García", caseNumber: "DV-2024-001", processType: "Divorcio", status: "Activo", priority: "Alta", responsiblePerson: "Lic. Juan Pérez", createdAt: Date()),
        Case(id: 2, name: "Herencia Martínez", clientName: "Juan Martínez", caseNumber: "PR-2024-015", processType: "Probate", status: "Pendiente", priority: "Media", responsiblePerson: "Lic. María Rodríguez", createdAt: Date().addingTimeInterval(-86400)),
        Case(id: 3, name: "Custodia López", clientName: "María López", caseNumber: "FC-2024-007", processType: "Familia", status: "Cerrado", priority: "Baja", responsiblePerson: "Lic. Carlos Sánchez", createdAt: Date().addingTimeInterval(-172800))
    ]
    
    var filteredCases: [Case] {
        if searchText.isEmpty {
            return cases
        } else {
            return cases.filter { $0.name.lowercased().contains(searchText.lowercased()) || $0.clientName.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCases) { caseItem in
                    CaseListItem(caseItem: caseItem)
                        .onTapGesture {
                            selectedCase = caseItem
                        }
                }
            }
            .listStyle(InsetGroupedListStyle())
            .searchable(text: $searchText, prompt: "Buscar casos")
            .navigationTitle("Mis Casos")
            .navigationBarItems(trailing: addButton)
            .sheet(isPresented: $isPresentingNewCaseView) {
                NewCaseView()
            }
            .sheet(item: $selectedCase) { caseItem in
                CaseDetailSheet(caseItem: caseItem)
            }
        }
    }
    
    private var addButton: some View {
        Button(action: {
            isPresentingNewCaseView = true
        }) {
            Image(systemName: "plus")
        }
    }
}

struct CaseListItem: View {
    let caseItem: Case
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(caseItem.name)
                    .font(.headline)
                Text(caseItem.clientName)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(caseItem.caseNumber)
                    .font(.caption)
                    .foregroundColor(.secondary)
                CaseStatusBadge(status: caseItem.status)
            }
        }
        .padding(.vertical, 8)
    }
}

struct CaseStatusBadge: View {
    let status: String
    
    var body: some View {
        Text(status)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(statusColor.opacity(0.2))
            .foregroundColor(statusColor)
            .cornerRadius(8)
    }
    
    private var statusColor: Color {
        switch status {
        case "Activo":
            return .green
        case "Pendiente":
            return .orange
        case "Cerrado":
            return .red
        default:
            return .gray
        }
    }
}

struct CaseDetailSheet: View {
    let caseItem: Case
    @State private var notes: String = ""
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CaseSummaryView(caseItem: caseItem)
                    CaseInformationView(caseItem: caseItem)
                    NotesSection(notes: $notes)
                    ActionButton(title: "Descargar Expediente", color: .blue, systemImage: "square.and.arrow.down") {
                        downloadCase()
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle(caseItem.name)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private func downloadCase() {
        print("Descargando caso: \(caseItem.caseNumber)")
    }
}

struct CaseSummaryView: View {
    let caseItem: Case
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resumen del Caso")
                .font(.title2)
                .fontWeight(.bold)
            
            HStack {
                Label(caseItem.clientName, systemImage: "person")
                Spacer()
                CaseStatusBadge(status: caseItem.status)
            }
            
            Label(caseItem.caseNumber, systemImage: "folder")
            
            Label(caseItem.processType, systemImage: "doc.text")
            
            Label(caseItem.priority, systemImage: "flag")
            
            Label(caseItem.responsiblePerson, systemImage: "person.fill")
            
            Label(formatDate(caseItem.createdAt), systemImage: "calendar")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct CaseInformationView: View {
    let caseItem: Case
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.title2)
                .fontWeight(.bold)
            
            InfoRow(title: "Nombre del Caso", value: caseItem.name)
            InfoRow(title: "Número de Expediente", value: caseItem.caseNumber)
            InfoRow(title: "Tipo de Proceso", value: caseItem.processType)
            InfoRow(title: "Estado", value: caseItem.status)
            InfoRow(title: "Prioridad", value: caseItem.priority)
            InfoRow(title: "Cliente", value: caseItem.clientName)
            InfoRow(title: "Responsable", value: caseItem.responsiblePerson)
            InfoRow(title: "Fecha de Creación", value: formatDate(caseItem.createdAt))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct InfoRow: View {
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct NotesSection: View {
    @Binding var notes: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Notas del Caso")
                .font(.title2)
                .fontWeight(.bold)
            
            TextEditor(text: $notes)
                .frame(height: 150)
                .padding(8)
                .background(Color(.systemBackground))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.secondary.opacity(0.2), lineWidth: 1)
                )
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ActionButton: View {
    let title: String
    let color: Color
    let systemImage: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: systemImage)
                Text(title)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
    }
}

struct Case: Identifiable {
    let id: Int
    let name: String
    let clientName: String
    let caseNumber: String
    let processType: String
    let status: String
    let priority: String
    let responsiblePerson: String
    let createdAt: Date
}

struct CaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CaseDetailView()
    }
}
