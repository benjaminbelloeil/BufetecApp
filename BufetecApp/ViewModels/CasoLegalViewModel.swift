import Foundation
import SwiftUI

class CasoLegalViewModel: ObservableObject {
    @Published var casos: [CasoLegal] = []
    @Published var caso: CasoLegal?
    @Published var clienteId: String?
    @Published var errorMessage: String? // Property to store error messages
    
    let urlPrefix = "http://10.14.255.54:5001/"
    
    init() {
        Task {
            await fetchCasos()
        }
    }
    
    func fetchCasos() async {
        let url = URL(string: "\(urlPrefix)casos")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch casos: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            // Print the raw data for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON response: \(jsonString)")
            }
            
            if let decodedResponse = try? JSONDecoder().decode([CasoLegal].self, from: data) {
                DispatchQueue.main.async {
                    self.casos = decodedResponse
                    self.errorMessage = nil // Clear any previous error messages
                    print("Fetched casos: \(self.casos)") // Debugging print statement
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch casos: \(error.localizedDescription)"
            }
        }
    }

    func fetchClienteIdByUserId(userId: String) async {
        guard var urlComponents = URLComponents(string: "\(urlPrefix)cliente") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        urlComponents.queryItems = [URLQueryItem(name: "user_id", value: userId)]
        
        guard let url = urlComponents.url else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch cliente: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
               let clienteId = json["id"] as? String {
                print("Fetched clienteId: \(clienteId)")
                DispatchQueue.main.async {
                    self.clienteId = clienteId
                }
            } else if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                      let message = json["message"] as? String {
                DispatchQueue.main.async {
                    self.errorMessage = message
                }
            } else {
                DispatchQueue.main.async {
                    self.errorMessage = "Invalid JSON structure"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch cliente: \(error.localizedDescription)"
            }
        }
    }

    func fetchCasoByClienteId(clienteId: String) async {
        guard let url = URL(string: "\(urlPrefix)caso/cliente/\(clienteId)") else {
            DispatchQueue.main.async {
                self.errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to fetch caso: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            // Print the JSON response
            if let jsonString = String(data: data, encoding: .utf8) {
                print("JSON Response: \(jsonString)")
            }
            
            // Print raw data
            print("Raw Data: \(data)")
            
            let decoder = JSONDecoder()
            do {
                let decodedResponse = try decoder.decode(CasoLegal.self, from: data)
                DispatchQueue.main.async {
                    self.caso = decodedResponse
                    self.errorMessage = nil
                }
            } catch {
                DispatchQueue.main.async {
                    self.errorMessage = "Failed to decode response: \(error.localizedDescription)"
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to fetch caso: \(error.localizedDescription)"
            }
        }
    }

    // Función para agregar un caso
    func addCaso(caso: CasoLegal) async {
        let url = URL(string: "\(urlPrefix)caso")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(caso) {
            request.httpBody = encoded
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to add caso: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.casos.append(caso)
                self.errorMessage = nil // Clear any previous error messages
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to add caso: \(error.localizedDescription)"
            }
        }
    }

    // Función para actualizar un caso
    func updateCaso(caso: CasoLegal) async {
        let url = URL(string: "\(urlPrefix)caso/\(caso.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(caso) {
            request.httpBody = encoded
        }
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to update caso: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                if let index = self.casos.firstIndex(where: { $0.id == caso.id }) {
                    self.casos[index] = caso
                    self.errorMessage = nil // Clear any previous error messages
                }
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to update caso: \(error.localizedDescription)"
            }
        }
    }
}
