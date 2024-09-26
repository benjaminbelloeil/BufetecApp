import SwiftUI

@Observable
class LawyerModel: Observable{
    
    var lawyers: [Lawyer] = []
    
    func fetchLawyers() async {
        
        lawyers.removeAll()
        let url = URL(string: "http://127.0.0.1:5001/abogados")!
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)!
        
        var request = URLRequest(url: components.url!)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        //        let (data) = try await URLSession.shared.data(for: request)
        //        print(String(decoding: data, as: UTF8.self))
      
        do {
                   let (data, _) = try await URLSession.shared.data(for: request)
                   print(String(decoding: data, as: UTF8.self))
                   if let decodedResponse = try? JSONDecoder().decode([Lawyer].self, from: data) {
                       lawyers = decodedResponse
                   }
               } catch {
                   print("Invalid data")
               }
           }
       }
