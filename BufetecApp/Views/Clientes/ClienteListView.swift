//
//  ClienteListView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/21/24.
//

import SwiftUI

struct ClienteListView: View {
    var clientes: [Cliente]
    @State private var searchText = ""

    var filteredClientes: [Cliente] {
        if searchText.isEmpty {
            return clientes
        } else {
            return clientes.filter { $0.name.lowercased().contains(searchText.lowercased()) ||
                                    $0.caseType.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredClientes) { cliente in
                        NavigationLink(destination: ClienteDetailView(cliente: cliente)) {
                            ClienteCard(cliente: cliente)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Clientes")
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Buscar clientes")
        }
    }
}

struct ClienteCard: View {
    var cliente: Cliente
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 80, height: 80)
                .foregroundColor(.blue)
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(cliente.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Label(cliente.caseType, systemImage: "folder")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label(cliente.status, systemImage: "circle.fill")
                    .font(.caption)
                    .foregroundColor(cliente.statusColor)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

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

struct ClienteDetailView: View {
    var cliente: Cliente
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ClienteInfoHeader(cliente: cliente)
                ClienteCaseInfo(cliente: cliente)
                ClienteContactInfo(cliente: cliente)
            }
            .padding()
        }
        .navigationTitle(cliente.name)
        .background(Color(.systemGroupedBackground))
    }
}

struct ClienteInfoHeader: View {
    var cliente: Cliente
    
    var body: some View {
        VStack(alignment: .center, spacing: 16) {
            Image(systemName: "person.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
            
            Text(cliente.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Label(cliente.status, systemImage: "circle.fill")
                .font(.subheadline)
                .foregroundColor(cliente.statusColor)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ClienteCaseInfo: View {
    var cliente: Cliente
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.headline)
            
            HStack {
                Label(cliente.caseType, systemImage: "folder")
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

struct ClienteListView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteListView(clientes: [
            Cliente(name: "María González", caseType: "Divorcio", status: "Activo"),
            Cliente(name: "Carlos Rodríguez", caseType: "Custodia", status: "En espera"),
            Cliente(name: "Ana Martínez", caseType: "Herencia", status: "Cerrado")
        ])
    }
}
