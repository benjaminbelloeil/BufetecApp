import SwiftUI

struct AbogadoListView: View {
    @State private var lawyers: [Lawyer] = []
    @State private var searchText = ""

    var filteredLawyers: [Lawyer] {
        if searchText.isEmpty {
            return lawyers
        } else {
            return lawyers.filter { $0.nombre.lowercased().contains(searchText.lowercased()) ||
                                    $0.especializacion.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(filteredLawyers) { lawyer in
                        NavigationLink(destination: AbogadoDetailView(lawyer: lawyer)) {
                            LawyerCard(lawyer: lawyer)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Abogados")
            .background(Color(.systemGroupedBackground))
            .searchable(text: $searchText, prompt: "Buscar abogados")
        }
        .onAppear {
            fetchLawyers()
        }
    }
    
    func fetchLawyers() {
        guard let url = URL(string: "http://localhost:5001/abogados") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let decodedResponse = try? JSONDecoder().decode([Lawyer].self, from: data) {
                    DispatchQueue.main.async {
                        self.lawyers = decodedResponse
                    }
                    return
                }
            }
            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
        }.resume()
    }
}

struct LawyerCard: View {
    var lawyer: Lawyer
    
    var body: some View {
        HStack(spacing: 16) {
            Circle()
                .fill(LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .frame(width: 80, height: 80)
                .overlay(
                    Text(lawyer.nombre.prefix(1).uppercased())
                        .font(.system(size: 32, weight: .bold))
                        .foregroundColor(.white)
                )
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(lawyer.nombre)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(lawyer.especializacion)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text("Experiencia: \(lawyer.experienciaProfesional)")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text("Casos ganados: \(lawyer.casosSentenciaFavorable)/\(lawyer.casosAtendidos)")
                    .font(.caption)
                    .foregroundColor(.green)
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

struct AbogadoListView_Previews: PreviewProvider {
    static var previews: some View {
        AbogadoListView()
    }
}
