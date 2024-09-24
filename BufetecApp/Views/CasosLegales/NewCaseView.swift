//
//  CaseDetailView.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//


// NewCaseView.swift
import SwiftUI

struct NewCaseView: View {
    // MARK: - State Properties
    @State private var caseName: String = ""
    @State private var caseNumber: String = ""
    @State private var clients: [Client] = [
        Client(id: 1, name: "Cliente 1"),
        Client(id: 2, name: "Cliente 2"),
        Client(id: 3, name: "Cliente 3")
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Profile and New Case Section
                    HStack(alignment: .top, spacing: 16) {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.blue)
                            .padding(.top)

                        VStack(alignment: .leading, spacing: 12) {
                            TextField("Nombre del caso", text: $caseName)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )

                            TextField("#Expediente", text: $caseNumber)
                                .padding()
                                .background(Color.gray.opacity(0.1))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.blue, lineWidth: 1)
                                )
                        }
                    }
                    .padding(.horizontal)

                    // Action Buttons Section
                    HStack(spacing: 20) {
                        ActionButton(title: "Añadir", color: .blue) {
                            // Acción de añadir
                            addCase()
                        }

                        ActionButton(title: "Eliminar", color: .red) {
                            // Acción de eliminar
                            removeCase()
                        }
                    }
                    .padding(.horizontal)

                    Divider()

                    // Clients Section
                    Text("Mis clientes")
                        .font(.headline)
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 16) {
                            ForEach(clients) { client in
                                ClientCard(client: client)
                            }
                        }
                        .padding(.horizontal)
                    }

                    // Add/Edit/Delete Buttons for Clients
                    HStack(spacing: 16) {
                        ActionButton(title: "Añadir", color: .blue) {
                            addClient()
                        }

                        ActionButton(title: "Editar", color: .orange) {
                            editClient()
                        }

                        ActionButton(title: "Eliminar", color: .red) {
                            deleteClient()
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical)
            }
            .navigationTitle("Nuevo caso")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    // MARK: - Action Methods
    private func addCase() {
        // Implementar lógica para añadir un caso
        print("Añadir caso")
    }

    private func removeCase() {
        // Implementar lógica para eliminar un caso
        print("Eliminar caso")
    }

    private func addClient() {
        let newId = (clients.map { $0.id }.max() ?? 0) + 1
        clients.append(Client(id: newId, name: "Cliente \(newId)"))
    }

    private func editClient() {
        // Implementar lógica de edición
        print("Editar cliente")
    }

    private func deleteClient() {
        if !clients.isEmpty {
            clients.removeLast()
        }
    }
}

struct NewCaseView_Previews: PreviewProvider {
    static var previews: some View {
        NewCaseView()
    }
}
