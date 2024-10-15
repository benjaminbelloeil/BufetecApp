import Foundation
import Combine

class LawyerModel: ObservableObject {
    @Published var lawyers: [Lawyer] = []
    
    func fetchLawyers() async {
        lawyers.removeAll()
        let url = URL(string: "http://10.14.255.54:5001/abogados")!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            print(String(decoding: data, as: UTF8.self))
            if let decodedResponse = try? JSONDecoder().decode([Lawyer].self, from: data) {
                DispatchQueue.main.async {
                    self.lawyers = decodedResponse
                }
            }
        } catch {
            print("Invalid data")
        }
    }
    
    func fetchLawyerName(by id: String) async -> String? {
    let url = URL(string: "http://10.14.255.54:5001/abogado/\(id)")!
    let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
    
    var request = URLRequest(url: components.url!)
    request.httpMethod = "GET"
    request.timeoutInterval = 10
    
    do {
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Print the raw data as a string
        let rawDataString = String(decoding: data, as: UTF8.self)
        print("Raw data: \(rawDataString)")
        
        // Attempt to decode the JSON response
        do {
            let decodedResponse = try JSONDecoder().decode(Lawyer.self, from: data)
            return decodedResponse.nombre
        } catch {
            print("Failed to decode response: \(error)")
        }
    } catch {
        print("Invalid data: \(error)")
    }
    return nil
}
}
