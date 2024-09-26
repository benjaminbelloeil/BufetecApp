//
//  BibliotecaViewModel.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

class BibliotecaViewModel: ObservableObject {
    
    @Published var bibliotecas: [Biblioteca] = []
    @Published var documentos: [Documento] = []
    @Published var chats: [Chat] = []
    @Published var lawyers: [Lawyer] = []
    
    let urlPrefix = "http://localhost:5001/biblioteca"
    
    init() {
        Task {
            await fetchBibliotecas()
            await fetchDocumentos()
            await fetchChats()
        }
    }
    
    // Fetch de bibliotecas
    func fetchBibliotecas() async {
        let url = URL(string: "\(urlPrefix)biblioteca")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Biblioteca].self, from: data) {
                bibliotecas = decodedResponse
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    // Fetch de documentos
    func fetchDocumentos() async {
        let url = URL(string: "\(urlPrefix)documentos")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Documento].self, from: data) {
                documentos = decodedResponse
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
    
    // Fetch de chats
    func fetchChats() async {
        let url = URL(string: "\(urlPrefix)chats")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Chat].self, from: data) {
                chats = decodedResponse
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }

    // Fetch de abogados (lawyers)
    func fetchLawyers() async {
        let url = URL(string: "http://localhost:5001/abogados")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            if let decodedResponse = try? JSONDecoder().decode([Lawyer].self, from: data) {
                DispatchQueue.main.async {
                    self.lawyers = decodedResponse
                }
            }
        } catch {
            print("Fetch failed: \(error.localizedDescription)")
        }
    }
}
