import SwiftUI

struct AbogadoListView: View {
    var lawyers: [Lawyer]
    @State private var searchText = ""

    var filteredLawyers: [Lawyer] {
        if searchText.isEmpty {
            return lawyers
        } else {
            return lawyers.filter { $0.name.lowercased().contains(searchText.lowercased()) ||
                                    $0.specialty.lowercased().contains(searchText.lowercased()) }
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
    }
}

struct LawyerCard: View {
    var lawyer: Lawyer
    
    var body: some View {
        HStack(spacing: 16) {
            Image(lawyer.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .shadow(radius: 3)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(lawyer.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Label(lawyer.specialty, systemImage: "briefcase")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Label(lawyer.caseType, systemImage: "doc.text")
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

struct AbogadoListView_Previews: PreviewProvider {
    static var previews: some View {
        AbogadoListView(lawyers: [
            Lawyer(name: "Lic. Ana María López", specialty: "Derecho Procesal", caseType: "Problemas Familiares", imageName: "avatar1"),
            Lawyer(name: "Lic. Juan Pérez", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2"),
            Lawyer(name: "Lic. Moka Diaz", specialty: "Derecho Laboral", caseType: "Conflictos Laborales", imageName: "avatar3")
        ])
    }
}
