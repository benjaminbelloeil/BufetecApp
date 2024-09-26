import SwiftUI

struct AbogadoListView: View {
    var lawyers: [Lawyer]
  
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(lawyers) { lawyer in
                        NavigationLink(destination: Text(lawyer.nombre)) { // AbogadoDetailView(lawyer: lawyer)
                            LawyerCard(lawyer: lawyer)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .navigationTitle("Abogados")
            .background(Color(.systemGroupedBackground))
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
                Text(lawyer.nombre)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Label(lawyer.especialidad, systemImage: "briefcase")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                VStack(alignment: .leading, spacing: 2) {
                    ForEach(lawyer.casos_asignados, id: \.self) { caso in
                        Label(caso, systemImage: "doc.text")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
            }
            Spacer()
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    // Lista de prueba de abogados para previsualización
    let sampleLawyers = [
        Lawyer(
            user_id: "66f32237273de98e8013e4f1",
            nombre: "Juan Pérez",
            especialidad: "Derecho Penal",
            experiencia_profesional: "10 años",
            disponibilidad: true,
            maestria: "Maestría en Derecho Penal",
            direccion: Direccion(calle: "Calle Falsa 123", ciudad: "Ciudad", estado: "Estado", codigo_postal: "12345"),
            telefono: "8112345678",
            correo: "juan.perez@example.com",
            casos_atendidos: 50,
            casos_con_setencia_a_favor: 45,
            casos_asignados: ["Caso A", "Caso B"],
            imageName: "lawyer1"
        ),
        Lawyer(
            user_id: "66f32237273de98e8013e4f2",
            nombre: "Maria García",
            especialidad: "Derecho Civil",
            experiencia_profesional: "5 años",
            disponibilidad: false,
            maestria: "Maestría en Derecho Civil",
            direccion: Direccion(calle: "Calle Verdadera 456", ciudad: "Otra Ciudad", estado: "Otro Estado", codigo_postal: "67890"),
            telefono: "8123456789",
            correo: "maria.garcia@example.com",
            casos_atendidos: 30,
            casos_con_setencia_a_favor: 25,
            casos_asignados: ["Caso C", "Caso D"],
            imageName: "lawyer2"
        )
    ]
    
    AbogadoListView(lawyers: sampleLawyers)
}
