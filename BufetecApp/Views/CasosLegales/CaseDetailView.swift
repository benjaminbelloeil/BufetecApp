import SwiftUI

struct CaseDetailView: View {
    @State private var selectedCase: Case?
    @State private var isPresentingNewCaseView = false
    @State private var searchText = ""
    
    let cases: [Case] = [
        Case(id: 1, title: "Divorcio García", clientName: "Ana García", caseNumber: "DV-2024-001", status: .active),
        Case(id: 2, title: "Herencia Martínez", clientName: "Juan Martínez", caseNumber: "PR-2024-015", status: .pending),
        Case(id: 3, title: "Custodia López", clientName: "María López", caseNumber: "FC-2024-007", status: .closed)
    ]
    
    var filteredCases: [Case] {
        if searchText.isEmpty {
            return cases
        } else {
            return cases.filter { $0.title.lowercased().contains(searchText.lowercased()) || $0.clientName.lowercased().contains(searchText.lowercased()) }
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
                Text(caseItem.title)
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
    let status: Case.Status
    
    var body: some View {
        Text(status.rawValue)
            .font(.caption2)
            .fontWeight(.bold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(status.color.opacity(0.2))
            .foregroundColor(status.color)
            .cornerRadius(8)
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
            .navigationTitle(caseItem.title)
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
            
            Label("Próxima audiencia: 15/10/2024", systemImage: "calendar")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct CaseInformationView: View {
    let caseItem: Case
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.title2)
                .fontWeight(.bold)
            
            InfoRow(title: "Juzgado", value: "3º Civil")
            InfoRow(title: "Juez", value: "Lic. Roberto Sánchez")
            InfoRow(title: "Parte contraria", value: "Carlos Rodríguez")
            InfoRow(title: "Abogado contrario", value: "Lic. Laura Gómez")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
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
    let title: String
    let clientName: String
    let caseNumber: String
    let status: Status
    
    enum Status: String {
        case active = "Activo"
        case pending = "Pendiente"
        case closed = "Cerrado"
        
        var color: Color {
            switch self {
            case .active: return .green
            case .pending: return .orange
            case .closed: return .red
            }
        }
    }
}

struct CaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CaseDetailView()
    }
}
