//
//  ClienteViewModel.swift
//  BufetecApp
//
//  
//

import Foundation

class ClienteViewModel: ObservableObject {
    
    @Published var clientes: [Cliente] = []
    
    let urlPrefix = "http://localhost:5001/"
    
    init() {
        Task {
            await fetchClientes()
        }
    }
    
    // Fetch de clientes
    func fetchClientes() async {
        let url = URL(string: "\(urlPrefix)cliente")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Cliente].self, from: data) {
                clientes = decodedResponse
            }
        } catch {
            print("Failed to fetch clientes: \(error.localizedDescription)")
        }
    }


    // Función para eliminar un cliente
    func deleteCliente(cliente: Cliente) async {
        let url = URL(string: "\(urlPrefix)cliente/\(cliente.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Eliminar localmente
            clientes.removeAll { $0.id == cliente.id }
        } catch {
            print("Failed to delete client")
        }
    }

    // Función para agregar un cliente
    func addCliente(cliente: Cliente) async {
        let url = URL(string: "\(urlPrefix)cliente")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cliente) {
            request.httpBody = encoded
        }
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Manejar éxito, por ejemplo, agregar el cliente localmente
            clientes.append(cliente)
        } catch {
            print("Failed to add client")
        }
    }

    // Función para actualizar un cliente
    func updateCliente(cliente: Cliente) async {
        let url = URL(string: "\(urlPrefix)cliente/\(cliente.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(cliente) {
            request.httpBody = encoded
        }
        
        do {
            let (_, _) = try await URLSession.shared.data(for: request)
            // Manejar éxito, por ejemplo, actualizar el cliente localmente
            if let index = clientes.firstIndex(where: { $0.id == cliente.id }) {
                clientes[index] = cliente
            }
        } catch {
            print("Failed to update client")
        }
    }
}
