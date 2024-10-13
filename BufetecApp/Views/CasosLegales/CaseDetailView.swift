import SwiftUI

struct CaseDetailView: View {
    @StateObject private var casoLegalViewModel = CasoLegalViewModel()
    @StateObject private var clienteViewModel = ClienteViewModel()
    @State private var selectedCase: CasoLegal?
    @State private var isPresentingNewCaseView = false
    @State private var searchText = ""

    var filteredCases: [CasoLegal] {
        if searchText.isEmpty {
            return casoLegalViewModel.casos
        } else {
            return casoLegalViewModel.casos.filter { 
                $0.nombre_caso.lowercased().contains(searchText.lowercased()) || 
                $0.cliente_id.lowercased().contains(searchText.lowercased()) 
            }
        }
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(filteredCases) { caseItem in
                    CaseListItem(caseItem: caseItem, clienteViewModel: clienteViewModel)
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
                CaseDetailSheet(caseItem: caseItem, clienteViewModel: clienteViewModel)
            }
            .onAppear {
                Task {
                    await casoLegalViewModel.fetchCasos()
                    await clienteViewModel.fetchClientes()
                }
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
    let caseItem: CasoLegal
    @ObservedObject var clienteViewModel: ClienteViewModel

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(caseItem.nombre_caso)
                    .font(.headline)
                Text(clienteName(for: caseItem.cliente_id))
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            VStack(alignment: .trailing, spacing: 4) {
                Text(caseItem.numero_expediente)
                    .font(.caption)
                    .foregroundColor(.secondary)
                CaseStatusBadge(status: caseItem.estado_proceso)
            }
        }
        .padding(.vertical, 8)
    }

    private func clienteName(for id: String) -> String {
        clienteViewModel.clientes.first { $0.id == id }?.nombre ?? "Desconocido"
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
        switch status.lowercased() {
        case "activo":
            return .green
        case "pendiente", "En espera":
            return .orange
        case "cerrado":
            return .red
        default:
            return .gray
        }
    }
}

struct CaseStatusProgressBar: View {
    let status: String

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 20)
                    .cornerRadius(10)

                Rectangle()
                    .fill(statusColor)
                    .frame(width: progressWidth(for: geometry.size.width), height: 20)
                    .cornerRadius(10)
            }
        }
        .frame(height: 20)
    }

    private var statusColor: Color {
        switch status.lowercased() {
        case "activo":
            return .green
        case "pendiente", "en espera":
            return .orange
        case "cerrado":
            return .red
        default:
            return .gray
        }
    }

    private func progressWidth(for totalWidth: CGFloat) -> CGFloat {
        switch status.lowercased() {
        case "activo":
            return totalWidth * 1.0
        case "pendiente", "en espera":
            return totalWidth * 0.5
        case "cerrado":
            return totalWidth * 0.0
        default:
            return totalWidth * 0.1
        }
    }
}

struct CaseDetailSheet: View {
    let caseItem: CasoLegal
    @ObservedObject var clienteViewModel: ClienteViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    CaseSummaryView(caseItem: caseItem, clienteViewModel: clienteViewModel)
                    CaseInformationView(caseItem: caseItem, clienteViewModel: clienteViewModel)
                    ActionButton(title: "Descargar Expediente", color: .blue, systemImage: "square.and.arrow.down") {
                        downloadCase()
                    }
                    .padding(.horizontal)
                }
                .padding()
            }
            .navigationTitle(caseItem.nombre_caso)
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func downloadCase() {
        print("Descargando caso: \(caseItem.numero_expediente)")
    }
}

struct CaseSummaryView: View {
    let caseItem: CasoLegal
    @ObservedObject var clienteViewModel: ClienteViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Resumen del Caso")
                .font(.title2)
                .fontWeight(.bold)

            HStack {
                Label(clienteName(for: caseItem.cliente_id), systemImage: "person")
                Spacer()
                CaseStatusProgressBar(status: caseItem.estado_proceso)
            }

            Label(caseItem.numero_expediente, systemImage: "folder")

            Label(caseItem.tipo_proceso, systemImage: "doc.text")

            Label(caseItem.prioridad, systemImage: "flag")

            Label(caseItem.responsable.joined(separator: ", "), systemImage: "person.fill")

            Label(formatDate(caseItem.fechaInicio ?? Date()), systemImage: "calendar")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func clienteName(for id: String) -> String {
        clienteViewModel.clientes.first { $0.id == id }?.nombre ?? "Desconocido"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

struct CaseInformationView: View {
    let caseItem: CasoLegal
    @ObservedObject var clienteViewModel: ClienteViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.title2)
                .fontWeight(.bold)

            InfoRow(title: "Nombre del Caso", value: caseItem.nombre_caso)
            InfoRow(title: "Número de Expediente", value: caseItem.numero_expediente)
            InfoRow(title: "Tipo de Proceso", value: caseItem.tipo_proceso)
            InfoRow(title: "Estado", value: caseItem.estado_proceso)
            InfoRow(title: "Prioridad", value: caseItem.prioridad)
            InfoRow(title: "Cliente", value: clienteName(for: caseItem.cliente_id))
            InfoRow(title: "Responsable", value: caseItem.responsable.joined(separator: ", "))
            InfoRow(title: "Fecha de Creación", value: formatDate(caseItem.fechaInicio ?? Date()))
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func clienteName(for id: String) -> String {
        clienteViewModel.clientes.first { $0.id == id }?.nombre ?? "Desconocido"
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

struct CaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CaseDetailView()
    }
}
