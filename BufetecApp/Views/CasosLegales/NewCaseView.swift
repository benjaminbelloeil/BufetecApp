import SwiftUI

struct NewCaseView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var caseName: String = ""
    @State private var caseNumber: String = ""
    @State private var processType: String = ""
    @State private var caseStatus: String = "En espera"
    @State private var priority: String = "Alta"
    @State private var selectedClient: CaseClient?
    @State private var responsiblePerson: String = ""
    @State private var createdAt: Date = Date()
    @State private var documents: [CaseDocument] = []
    
    @State private var clients: [CaseClient] = [
        CaseClient(id: 1, name: "Cliente 1"),
        CaseClient(id: 2, name: "Cliente 2"),
        CaseClient(id: 3, name: "Cliente 3")
    ]
    @State private var showingClientSheet = false
    @State private var clientAction: ClientAction = .add

    enum ClientAction {
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
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Nuevo Caso")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .sheet(isPresented: $showingClientSheet) {
                ClientFormView(action: clientAction, client: selectedClient, onSave: handleClientSave)
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
                    ForEach(clients) { client in
                        ClientCard(client: client, isSelected: client == selectedClient)
                            .onTapGesture {
                                selectedClient = client
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
        print("Añadir caso: \(caseName), Expediente: \(caseNumber), Tipo: \(processType), Estado: \(caseStatus), Prioridad: \(priority), Cliente: \(selectedClient?.name ?? "Ninguno"), Responsable: \(responsiblePerson), Fecha: \(createdAt)")
        presentationMode.wrappedValue.dismiss()
    }

    private func removeCase() {
        // Implement logic to cancel case creation
        presentationMode.wrappedValue.dismiss()
    }

    private func deleteClient() {
        if let selected = selectedClient, let index = clients.firstIndex(where: { $0.id == selected.id }) {
            clients.remove(at: index)
            selectedClient = nil
        }
    }

    private func handleClientSave(client: CaseClient) {
        if let index = clients.firstIndex(where: { $0.id == client.id }) {
            clients[index] = client
        } else {
            clients.append(client)
        }
        selectedClient = client
        showingClientSheet = false
    }
}

struct ClientCard: View {
    let client: CaseClient
    var isSelected: Bool = false

    var body: some View {
        VStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 50, height: 50)
                .foregroundColor(isSelected ? .blue : .gray)

            Text(client.name)
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

struct ClientFormView: View {
    let action: NewCaseView.ClientAction
    let client: CaseClient?
    let onSave: (CaseClient) -> Void

    @State private var name: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Nombre del cliente", text: $name)
            }
            .navigationTitle(action == .add ? "Añadir Cliente" : "Editar Cliente")
            .navigationBarItems(
                leading: Button("Cancelar") { presentationMode.wrappedValue.dismiss() },
                trailing: Button("Guardar") {
                    let newClient = CaseClient(id: client?.id ?? UUID().hashValue, name: name)
                    onSave(newClient)
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .onAppear {
            if let client = client {
                name = client.name
            }
        }
    }
}

struct CaseClient: Identifiable, Equatable {
    let id: Int
    var name: String
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
