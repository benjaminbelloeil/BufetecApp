import SwiftUI

struct ClienteListView: View {
    var clientes: [Cliente]
    var casosLegales: [CasoLegal]
    @State private var searchText = ""

    var filteredClientes: [Cliente] {
        if searchText.isEmpty {
            return clientes
        } else {
            return clientes.filter { cliente in
                let matchingCasos = casosLegales.filter { $0.idCliente == cliente.id }
                let clienteMatches = cliente.name.lowercased().contains(searchText.lowercased())
                let casoMatches = matchingCasos.contains { $0.nombre.lowercased().contains(searchText.lowercased()) || $0.estado.lowercased().contains(searchText.lowercased()) }
                return clienteMatches || casoMatches
            }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredClientes) { cliente in
                        let matchingCasos = casosLegales.filter { $0.idCliente == cliente.id }
                        NavigationLink(destination: ClienteDetailView(cliente: cliente, casosLegales: casosLegales)) {
                            ClienteCard(cliente: cliente, casos: matchingCasos)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Clientes")
        }
    }
}

struct ClienteCard: View {
    var cliente: Cliente
    var casos: [CasoLegal]

    var body: some View {
        VStack(alignment: .leading) {
            Text(cliente.name)
                .font(.headline)
            ForEach(casos) { caso in
                Text("Caso: \(caso.nombre) - Estado: \(caso.estado)")
                    .font(.subheadline)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 4)
    }
}
struct ClienteDetailView: View {
    var cliente: Cliente
    var casosLegales: [CasoLegal]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                ClienteInfoHeader(cliente: cliente)
                ClienteCaseInfo(cliente: cliente, casos: casosLegales.filter { $0.idCliente == cliente.id })
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
    var casos: [CasoLegal]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Información del Caso")
                .font(.headline)
            
            ForEach(casos) { caso in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Label(caso.nombre, systemImage: "folder")
                        Spacer()
                        Text("Estado: \(caso.estado)")
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
        ], casosLegales: [
            CasoLegal(idCliente: UUID(), idAbogado: UUID(), nombre: "Divorcio", expediente: "blablabla", parteActora: "blablabla", parteDemandada: "blablabla", estado: "Activo", notas: "no se"),
            CasoLegal(idCliente: UUID(), idAbogado: UUID(), nombre: "Divorcio", expediente: "blablabla", parteActora: "blablabla", parteDemandada: "blablabla", estado: "Activo", notas: "no se"),
            CasoLegal(idCliente: UUID(), idAbogado: UUID(), nombre: "Divorcio", expediente: "blablabla", parteActora: "blablabla", parteDemandada: "blablabla", estado: "Activo", notas: "no se")
        ])
    }
}


/**
 struct CasoLegal: Identifiable {
     var id = UUID()
     var idCliente = UUID()
     var idAbogado = UUID()
     var nombre: String
     var expediente: String
     var parteActora: String
     var parteDemandada: String
     var estado: String
     var perfilCliente: String
     var notas: String
 }

 
 */
