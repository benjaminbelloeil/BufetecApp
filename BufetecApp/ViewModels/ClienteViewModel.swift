import Foundation

class ClienteViewModel: ObservableObject {
    @Published var clientes: [Cliente] = []
    @Published var errorMessage: String? // Property to store error messages
    
    let urlPrefix = "http://localhost:5001/"
    
    init() {
        Task {
            await fetchClientes()
        }
    }
    
    func fetchClientes() async {
        let url = URL(string: "\(urlPrefix)clientes")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch clients: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            // Print the raw data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            if let decodedResponse = try? JSONDecoder.custom.decode([Cliente].self, from: data) {
                DispatchQueue.main.async {
                    self.clientes = decodedResponse
                    self.errorMessage = nil // Clear any previous error messages
                    print("Fetched clientes: \(self.clientes)") // Debugging print statement
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch clients: \(error.localizedDescription)"
            }
        }
    }

    // Other methods (deleteCliente, addCliente, updateCliente) remain the same

    // Función para eliminar un cliente
    func deleteCliente(cliente: Cliente) async {
        let url = URL(string: "\(urlPrefix)cliente/\(cliente.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to delete client: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.clientes.removeAll { $0.id == cliente.id }
                self.errorMessage = nil // Clear any previous error messages
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to delete client: \(error.localizedDescription)"
            }
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
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to add client: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.clientes.append(cliente)
                self.errorMessage = nil // Clear any previous error messages
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to add client: \(error.localizedDescription)"
            }
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
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to update client: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                if let index = self.clientes.firstIndex(where: { $0.id == cliente.id }) {
                    self.clientes[index] = cliente
                    self.errorMessage = nil // Clear any previous error messages
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to update client: \(error.localizedDescription)"
            }
        }
    }
}