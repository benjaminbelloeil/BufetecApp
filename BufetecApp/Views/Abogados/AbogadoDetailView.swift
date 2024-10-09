import SwiftUI

struct AbogadoDetailView: View {
    var lawyer: Lawyer
    @State private var isContactExpanded = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Lawyer image and name
                VStack {
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 120, height: 120)
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                    
                    Text(lawyer.nombre)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Text(lawyer.especializacion)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.blue.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .foregroundColor(.white)
                .cornerRadius(15)

                // Lawyer details
                VStack(alignment: .leading, spacing: 15) {
                    detailRow(icon: "briefcase", title: "Especialidad", detail: lawyer.especializacion)
                    detailRow(icon: "book", title: "Maestría", detail: lawyer.maestria ?? "No disponible")
                    detailRow(icon: "clock", title: "Experiencia", detail: lawyer.experienciaProfesional)
                    detailRow(icon: "mappin", title: "Dirección", detail: formatAddress(lawyer.direccion))
                    detailRow(icon: "phone", title: "Teléfono", detail: lawyer.telefono)
                    detailRow(icon: "envelope", title: "Correo", detail: lawyer.correo)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 5)

                // Statistics
                HStack(spacing: 15) {
                    statisticCard(title: "Casos atendidos", value: "\(lawyer.casosAtendidos)")
                    statisticCard(title: "Casos ganados", value: "\(lawyer.casosSentenciaFavorable)")
                    statisticCard(title: "Tasa de éxito", value: "\(calculateSuccessRate(lawyer))%")
                }

                // Contact button
                Button(action: {
                    isContactExpanded.toggle()
                }) {
                    Text(isContactExpanded ? "Ocultar opciones de contacto" : "Contactar abogado")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }

                if isContactExpanded {
                    VStack(spacing: 10) {
                        Button(action: {
                            // Action to call
                        }) {
                            Label("Llamar", systemImage: "phone")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            // Action to send email
                        }) {
                            Label("Enviar correo", systemImage: "envelope")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("Detalle del Abogado")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
    }
    
    private func detailRow(icon: String, title: String, detail: String) -> some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                Text(detail)
                    .font(.body)
            }
        }
    }
    
    private func statisticCard(title: String, value: String) -> some View {
        VStack {
            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.blue)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
    
    private func formatAddress(_ direccion: Lawyer.Direccion) -> String {
        return "\(direccion.calle), \(direccion.ciudad), \(direccion.estado) \(direccion.codigo_postal)"
    }
    
    private func calculateSuccessRate(_ lawyer: Lawyer) -> Int {
        // Unwrap the optional values with default values (0 in this case)
        let casosAtendidos = lawyer.casosAtendidos
        let casosSentenciaFavorable = lawyer.casosSentenciaFavorable
        
        // Ensure there are attended cases to avoid division by zero
        guard casosAtendidos > 0 else { return 0 }
        
        // Perform the calculation
        return Int((Double(casosSentenciaFavorable) / Double(casosAtendidos)) * 100)
    }

}

struct AbogadoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AbogadoDetailView(lawyer: Lawyer(
                id: UUID().uuidString,
                userId: "user1",
                nombre: "Lic. Ana María López",
                especializacion: "Derecho Procesal",
                experienciaProfesional: "10 años en litigio",
                disponibilidad: true,
                maestria: "Maestría en Derecho Procesal",
                direccion: Lawyer.Direccion(calle: "Av. Revolución 123", ciudad: "Monterrey", estado: "Nuevo León", codigo_postal: "64000"),
                casosAsignados: [],
                telefono: "8112345678",
                correo: "ana.lopez@ejemplo.com",
                casosAtendidos: 100,
                casosSentenciaFavorable: 80,
                imageName: "avatar1"
            ))
        }
    }
}
