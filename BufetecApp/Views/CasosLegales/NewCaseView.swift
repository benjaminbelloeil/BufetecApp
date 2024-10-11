import SwiftUI

struct NewCaseView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var casoLegalViewModel = CasoLegalViewModel()
    @StateObject private var clientViewModel = ClienteViewModel()
    @State private var caseName: String = ""
    @State private var caseNumber: String = ""
    @State private var processType: String = ""
    @State private var caseStatus: String = "En espera"
    @State private var priority: String = "Alta"
    @State private var selectedClient: Cliente?
    @State private var responsiblePerson: String = ""
    @State private var createdAt: Date = Date()
    @State private var documents: [CaseDocument] = []
    @State private var showingClientSheet = false
    @State private var clientAction: ClienteAction = .add

    enum ClienteAction {
        case add, edit
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    caseInfoSection
                    clientsSection
                    documentsSection
                    actionButtonsSection
                    casosLegalesSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Nuevo Caso")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .onAppear {
                Task {
                    await casoLegalViewModel.fetchCasos()
                    await clientViewModel.fetchClientes()
                }
            }
        }
    }

    private var caseInfoSection: some View {
        VStack(spacing: 16) {
            TextField("Nombre del caso", text: $caseName)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("#Expediente", text: $caseNumber)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Tipo de proceso", text: $processType)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Estado del Proceso", text: $caseStatus)
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Picker("Prioridad", selection: $priority) {
                Text("Alta").tag("Alta")
                Text("Media").tag("Media")
                Text("Baja").tag("Baja")
            }
            .pickerStyle(SegmentedPickerStyle())
            
            TextField("Responsable", text: $responsiblePerson)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            DatePicker("Fecha de creación", selection: $createdAt, displayedComponents: .date)
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var clientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Clientes Asignados")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(clientViewModel.clientes) { cliente in
                        ClienteCard(cliente: cliente)
                            .onTapGesture {
                                selectedClient = cliente
                            }
                    }
                }
            }

            HStack(spacing: 12) {
                Button(action: {
                    clientAction = .add
                    showingClientSheet = true
                }) {
                    Label("Añadir", systemImage: "plus")
                }
                .buttonStyle(BorderedProminentButtonStyle())

                Button(action: deleteClient) {
                    Label("Eliminar", systemImage: "trash")
                }
                .buttonStyle(BorderedButtonStyle())
                .disabled(selectedClient == nil)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Documentos")
                .font(.headline)

            ForEach(documents) { document in
                HStack {
                    Image(systemName: "doc")
                    Text(document.name)
                    Spacer()
                    Button(action: {
                        // Implement document deletion
                    }) {
                        Image(systemName: "trash")
                    }
                }
            }

            Button(action: {
                // Implement document addition
            }) {
                Label("Añadir Documento", systemImage: "plus")
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var actionButtonsSection: some View {
        HStack(spacing: 16) {
            Button(action: addCase) {
                Text("Guardar Caso")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedProminentButtonStyle())

            Button(action: removeCase) {
                Text("Cancelar")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(BorderedButtonStyle())
        }
    }

    private var casosLegalesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Casos Legales")
                .font(.headline)

            ForEach(casoLegalViewModel.casos) { caso in
                VStack(alignment: .leading) {
                    Text("Nombre del Caso: \(caso.nombre_caso)")
                    Text("Número de Expediente: \(caso.numero_expediente)")
                    Text("Cliente ID: \(caso.cliente_id)")
                    Text("Abogado ID: \(caso.abogado_id)")
                    Text("Tipo de Proceso: \(caso.tipo_proceso)")
                    Text("Estado del Proceso: \(caso.estado_proceso)")
                    Text("Prioridad: \(caso.prioridad)")
                    Text("Fecha de Inicio: \(caso.fechaInicio?.description ?? "N/A")")
                    Text("Fecha de Fin: \(caso.fecha_fin?.description ?? "N/A")")
                    Text("Documentos:")
                    ForEach(caso.documentos, id: \.nombre) { documento in
                        Text("  - \(documento.nombre): \(documento.url)")
                    }
                    Text("Responsables:")
                    ForEach(caso.responsable, id: \.self) { responsable in
                        Text("  - \(responsable)")
                    }
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
    }

    private var cancelButton: some View {
        Button("Cancelar") {
            presentationMode.wrappedValue.dismiss()
        }
    }

    private var saveButton: some View {
        Button("Guardar") {
            addCase()
        }
    }

    private func addCase() {
        // Implement logic to add a case
        print("Añadir caso: \(caseName), Expediente: \(caseNumber), Tipo: \(processType), Estado: \(caseStatus), Prioridad: \(priority), Cliente: \(selectedClient?.nombre ?? "Ninguno"), Responsable: \(responsiblePerson), Fecha: \(createdAt)")
        presentationMode.wrappedValue.dismiss()
    }

    private func removeCase() {
        // Implement logic to cancel case creation
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteClient() {
        if let selected = selectedClient, let index = clientViewModel.clientes.firstIndex(where: { $0.id == selected.id }) {
            clientViewModel.clientes.remove(at: index)
            selectedClient = nil
        }
    }

    private func handleClientSave(client: Cliente) {
        if let index = clientViewModel.clientes.firstIndex(where: { $0.id == client.id }) {
            clientViewModel.clientes[index] = client
        } else {
            clientViewModel.clientes.append(client)
        }
        selectedClient = client
        showingClientSheet = false
    }
}

struct ClientCard: View {
    let cliente: Cliente
    var isSelected: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(isSelected ? .blue : .gray)

            Text(cliente.nombre)
                .font(.caption)
                .lineLimit(2)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80, height: 100)
        .padding(8)
        .background(isSelected ? Color.blue.opacity(0.1) : Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
    }
}


struct CaseDocument: Identifiable {
    let id: UUID
    var name: String
}

struct NewCaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewCaseView()
    }
}
