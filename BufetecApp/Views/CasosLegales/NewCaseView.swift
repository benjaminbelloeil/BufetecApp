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
    @State private var abogadoId: String = "670b3dd3defd761576ebb5e8" // Define abogado_id as a @State property

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    caseInfoSection
                    clientAssignmentSection
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

    private var actionButtonsSection: some View {
        HStack(spacing: 16) {


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
        guard let selectedClient = selectedClient else {
            print("No client selected")
            return
        }

        let clientId = selectedClient.id
        let clientUpdateURL = URL(string: "http://10.14.255.54:5001/cliente/\(clientId)")!
        let caseCreateURL = URL(string: "http://10.14.255.54:5001/caso")!

                // Create the request body for the PUT request
        let clientUpdateBody: [String: Any] = [
            "_id": ["$oid": selectedClient.id],
            "nombre": selectedClient.nombre,
            "contacto": selectedClient.contacto,
            "telefono": selectedClient.telefono,
            "correo": selectedClient.correo,
            "direccion": [
                "calle": selectedClient.direccion.calle,
                "ciudad": selectedClient.direccion.ciudad,
                "estado": selectedClient.direccion.estado,
                "codigo_postal": selectedClient.direccion.codigo_postal
            ],
            "disponibilidad": false
        ]

               // Create the request body for the POST request
        let caseCreateBody: [String: Any] = [
            "nombre_caso": caseName,
            "numero_expediente": caseNumber,
            "tipo_proceso": processType,
            "estado_proceso": caseStatus,
            "prioridad": priority,
            "cliente_id": clientId,
            "abogado_id": abogadoId, // Use the abogadoId property
            "documentos": [], // Start with an empty documentos array
            "responsable": [responsiblePerson] // Ensure responsable is a string array
        ]
        // Perform the PUT request to update the client's disponibilidad
        var clientUpdateRequest = URLRequest(url: clientUpdateURL)
        clientUpdateRequest.httpMethod = "PUT"
        clientUpdateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        clientUpdateRequest.httpBody = try? JSONSerialization.data(withJSONObject: clientUpdateBody)

        URLSession.shared.dataTask(with: clientUpdateRequest) { data, response, error in
            if let error = error {
                print("Failed to update client: \(error)")
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                print("Failed to update client: Invalid response")
                return
            }

            // Perform the POST request to create the new case
            var caseCreateRequest = URLRequest(url: caseCreateURL)
            caseCreateRequest.httpMethod = "POST"
            caseCreateRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            caseCreateRequest.httpBody = try? JSONSerialization.data(withJSONObject: caseCreateBody)

            URLSession.shared.dataTask(with: caseCreateRequest) { data, response, error in
                if let error = error {
                    print("Failed to create case: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    print("Failed to create case: Invalid response")
                    return
                }

                print("Case created successfully")
                DispatchQueue.main.async {
                    presentationMode.wrappedValue.dismiss()
                }
            }.resume()
        }.resume()
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
