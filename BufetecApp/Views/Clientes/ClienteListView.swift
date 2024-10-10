//
//  ClienteListView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/21/24.
//

import SwiftUI

struct ClienteListView: View {
    @ObservedObject var viewModel = ClienteViewModel()
    var casosLegales: [CasoLegal]
    @State private var searchText = ""

    var filteredClientes: [Cliente] {
        if searchText.isEmpty {
            return viewModel.clientes
        } else {
            return filteredClientesBySearchText
        }
    }

    private var filteredClientesBySearchText: [Cliente] {
        viewModel.clientes.filter { cliente in
            cliente.nombre.lowercased().contains(searchText.lowercased())
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    clienteListContent
                }
                .padding()
            }
            .navigationTitle("Clientes")
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Buscar clientes")
        }
    }

    private var clienteListContent: some View {
        ForEach(filteredClientes) { cliente in
            clienteNavigationLink(for: cliente)
        }
    }

    private func clienteNavigationLink(for cliente: Cliente) -> some View {
        if let caso = casosLegales.first(where: { $0.idCliente == cliente.id }) {
            return AnyView(
                NavigationLink(destination: ClienteDetailView(cliente: cliente, caso: caso)) {
                    ClienteCard(cliente: cliente, caso: caso)
                }
                .buttonStyle(PlainButtonStyle())
            )
        } else {
            return AnyView(
                NavigationLink(destination: ClienteDetailView(cliente: cliente, caso: nil)) {
                    ClienteCard(cliente: cliente, caso: nil)
                }
                .buttonStyle(PlainButtonStyle())
            )
        }
    }
}

struct ClienteCard: View {
    var cliente: Cliente
    var caso: CasoLegal?

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .shadow(radius: 3)

            VStack(alignment: .leading, spacing: 8) {
                Text(cliente.nombre)
                    .font(.headline)
                    .foregroundColor(.primary)

                if let caso = caso {
                    Text(caso.nombre)
                        .font(.subheadline)
                        .foregroundColor(.secondary)

                    Text(caso.estado)
                        .font(.caption)
                        .foregroundColor(.secondary)
                } else {
                    Text("No casos legales")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct ClienteDetailView: View {
    var cliente: Cliente
    var caso: CasoLegal?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ClienteInfoHeader(cliente: cliente, caso: caso)
                if let caso = caso {
                    ClienteCaseInfo(cliente: cliente, caso: caso)
                }
                ClienteContactInfo(cliente: cliente)
            }
            .padding()
        }
        .navigationTitle(cliente.nombre)
        .background(Color(.systemGroupedBackground))
    }
}

struct ClienteInfoHeader: View {
    var cliente: Cliente
    var caso: CasoLegal?

    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)

            Text(cliente.nombre)
                .font(.title2)
                .fontWeight(.bold)

            if let caso = caso {
                Label(caso.estado, systemImage: "circle.fill")
                    .font(.subheadline)
                    .foregroundColor(.red)
            } else {
                Text("No casos legales")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ClienteCaseInfo: View {
    var cliente: Cliente
    var caso: CasoLegal

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.headline)

            HStack {
                Label(caso.nombre, systemImage: "folder")
                Spacer()
                Text("Caso #12345")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Text("Abogado asignado: Lic. Juan Pérez")
            Text("Fecha de inicio: 01/01/2024")
            Text("Próxima audiencia: 15/03/2024")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ClienteContactInfo: View {
    var cliente: Cliente

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información de Contacto")
                .font(.headline)

            Label("cliente@email.com", systemImage: "envelope")
            Label("+52 123 456 7890", systemImage: "phone")
            Label("Calle Principal 123, Ciudad", systemImage: "location")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

import SwiftUI

struct ClienteListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ClienteViewModel()
        
        // Wait for the viewModel to fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewModel.clientes.isEmpty {
                let casosLegales = [
                    CasoLegal(
                        id: "1",
                        idCliente: viewModel.clientes[0].id,
                        idAbogado: "1",
                        nombre: "Divorcio",
                        expediente: "EXP123",
                        parteActora: "John Doe",
                        parteDemandada: "Jane Doe",
                        estado: "Activo",
                        notas: "Notas del caso de divorcio",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    ),
                    CasoLegal(
                        id: "2",
                        idCliente: viewModel.clientes[1].id,
                        idAbogado: "1",
                        nombre: "Custodia",
                        expediente: "EXP456",
                        parteActora: "Alice Smith",
                        parteDemandada: "Bob Smith",
                        estado: "En espera",
                        notas: "Notas del caso de custodia",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    ),
                    CasoLegal(
                        id: "3",
                        idCliente: viewModel.clientes[2].id,
                        idAbogado: "2",
                        nombre: "Herencia",
                        expediente: "EXP789",
                        parteActora: "Charlie Brown",
                        parteDemandada: "Lucy Brown",
                        estado: "Cerrado",
                        notas: "Notas del caso de herencia",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    )
                ]
                
                ClienteListView(viewModel: viewModel, casosLegales: casosLegales)
            }
        }
        
        return ClienteListView(viewModel: viewModel, casosLegales: [])
    }
}