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
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 70, height: 70)
                    .foregroundColor(.blue)
                    .background(Color.white)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.blue, lineWidth: 2))
                    .shadow(radius: 5)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(lawyer.nombre)
                        .font(.title3)
                        .fontWeight(.bold)
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
            }
            
            HStack {
                Label(lawyer.correo, systemImage: "envelope")
                    .font(.caption)
                    .foregroundColor(.blue)
                
                Spacer()
                
                Label(lawyer.telefono, systemImage: "phone")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)
    }
}

struct AbogadoListView_Previews: PreviewProvider {
    static var previews: some View {
        AbogadoListView()
    }
}
