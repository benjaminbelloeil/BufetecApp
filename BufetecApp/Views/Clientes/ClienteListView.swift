import SwiftUI

struct ClienteListView: View {
    @ObservedObject var viewModel = ClienteViewModel()
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
        NavigationLink(destination: ClienteDetailView(cliente: cliente)) {
            ClienteCard(cliente: cliente)
        }
        .buttonStyle(PlainButtonStyle())
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
                Text(cliente.nombre)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(cliente.contacto)
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                Text(cliente.telefono)
                    .font(.caption)
                    .foregroundColor(.secondary)
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

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ClienteInfoHeader(cliente: cliente)
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

            Text(cliente.contacto)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
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

            Label(cliente.correo, systemImage: "envelope")
            Label(cliente.telefono, systemImage: "phone")
            Label("\(cliente.direccion.calle), \(cliente.direccion.ciudad)", systemImage: "location")
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }
}

struct ClienteListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = ClienteViewModel()
        
        // Wait for the viewModel to fetch data
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if !viewModel.clientes.isEmpty {
                ClienteListView(viewModel: viewModel)
            }
        }
        
        return ClienteListView(viewModel: viewModel)
    }
}