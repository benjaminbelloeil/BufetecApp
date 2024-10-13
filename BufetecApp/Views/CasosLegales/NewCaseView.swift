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

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    caseInfoSection
                    clientAssignmentSection
                    documentsSection
                    clientsSection
                    actionButtonsSection
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
            .navigationTitle("Nuevo Caso")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: cancelButton, trailing: saveButton)
            .onAppear {
                Task {
                    await casoLegalViewModel.fetchCasos()
                    await clientViewModel.fetchClientes()
                }
            }
            .sheet(isPresented: $showingClientSheet) {
                ClientSelectionSheet(selectedClient: $selectedClient, clientViewModel: clientViewModel)
            }
        }
    }

    private var caseInfoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información del Caso")
                .font(.headline)
                .padding(.bottom, 8)

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
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private var clientAssignmentSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Cliente Asignado")
                .font(.headline)
                .padding(.bottom, 8)

            if let selectedClient = selectedClient {
                ClienteCard2(cliente: selectedClient, isSelected: true)
            } else {
                Text("Ningún cliente asignado")
                    .foregroundColor(.secondary)
            }

            Button(action: {
                showingClientSheet = true
            }) {
                Label("Asignar Cliente", systemImage: "person.badge.plus")
            }
            .buttonStyle(BorderedProminentButtonStyle())
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private var clientsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Clientes en Espera")
                .font(.headline)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(clientViewModel.clientes.filter { $0.disponibilidad && $0.id != selectedClient?.id }) { cliente in
                        ClienteCard2(cliente: cliente, isSelected: false)
                            .onTapGesture {
                                selectedClient = cliente
                            }
                    }
                }
            }
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }

    private var documentsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Documentos")
                .font(.headline)

            ForEach(documents) { document in
                HStack {
                    Image(systemName: "doc")
                        .foregroundColor(.blue)
                    Text(document.name)
                    Spacer()
                    Button(action: {
                        // Implement document deletion
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
                .padding(.vertical, 8)
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
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
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
        print("Añadir caso: \(caseName), Expediente: \(caseNumber), Tipo: \(processType), Estado: \(caseStatus), Prioridad: \(priority), Cliente: \(selectedClient?.nombre ?? "Ninguno"), Responsable: \(responsiblePerson), Fecha: \(createdAt)")
        presentationMode.wrappedValue.dismiss()
    }

    private func removeCase() {
        // Implement logic to cancel case creation
        presentationMode.wrappedValue.dismiss()
    }
}

struct ClienteCard2: View {
    let cliente: Cliente
    let isSelected: Bool

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(isSelected ? .blue : .gray)

            Text(cliente.nombre)
                .font(.subheadline)
                .lineLimit(1)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
        .background(isSelected ? Color(.systemBlue).opacity(0.1) : Color(.tertiarySystemGroupedBackground))
        .cornerRadius(8)
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

struct ClientSelectionSheet: View {
    @Binding var selectedClient: Cliente?
    let clientViewModel: ClienteViewModel
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            List(clientViewModel.clientes.filter { $0.disponibilidad }) { cliente in
                Button {
                    selectedClient = cliente
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    ClienteCard2(cliente: cliente, isSelected: false)
                }
            }
            .navigationTitle("Seleccionar Cliente")
            .navigationBarItems(trailing: Button("Cancelar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
