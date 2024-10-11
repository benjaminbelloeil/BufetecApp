import Foundation
import SwiftUI

class CasoLegalViewModel: ObservableObject {
    @Published var casos: [CasoLegal] = []
    @Published var errorMessage: String? // Property to store error messages
    
    let urlPrefix = "http://localhost:5001/"
    
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

    // Función para eliminar un caso
    func deleteCaso(caso: CasoLegal) async {
        let url = URL(string: "\(urlPrefix)caso/\(caso.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.timeoutInterval = 10
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    DispatchQueue.main.async {
                        self.errorMessage = "Failed to delete caso: \(httpResponse.statusCode)"
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.casos.removeAll { $0.id == caso.id }
                self.errorMessage = nil // Clear any previous error messages
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "Failed to delete caso: \(error.localizedDescription)"
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