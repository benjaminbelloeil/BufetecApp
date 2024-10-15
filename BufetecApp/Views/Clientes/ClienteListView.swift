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
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(cliente.nombre.prefix(1).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)

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
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
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
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 120, height: 120)
                .overlay(
                    Text(cliente.nombre.prefix(1).uppercased())
                        .font(.system(size: 48, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

            Text(cliente.nombre)
                .font(.title2)
                .fontWeight(.bold)

            Text(cliente.contacto)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
        )
    }
}

struct ClienteContactInfo: View {
    var cliente: Cliente

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Información de Contacto")
                .font(.headline)
                .padding(.bottom, 8)

            ContactInfoRow(icon: "envelope", text: cliente.correo)
            ContactInfoRow(icon: "phone", text: cliente.telefono)
            ContactInfoRow(icon: "location", text: "\(cliente.direccion.calle ?? "nose"), \(cliente.direccion.ciudad ?? "nose")")
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(.secondarySystemBackground))
                .shadow(color: Color.black.opacity(0.05), radius: 15, x: 0, y: 10)
        )
    }
}

struct ContactInfoRow: View {
    var icon: String
    var text: String

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24, height: 24)
            Text(text)
                .foregroundColor(.secondary)
        }
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
