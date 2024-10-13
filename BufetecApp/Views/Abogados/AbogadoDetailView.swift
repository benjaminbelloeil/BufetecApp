import SwiftUI

struct AbogadoDetailView: View {
    var lawyer: Lawyer
    @State private var isContactExpanded = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Lawyer image and name
                VStack(spacing: 16) {
                    Circle()
                        .fill(LinearGradient(gradient: Gradient(colors: [Color.blue.opacity(0.8), Color.purple.opacity(0.8)]), startPoint: .topLeading, endPoint: .bottomTrailing))
                        .frame(width: 140, height: 140)
                        .overlay(
                            Text(lawyer.nombre.prefix(1).uppercased())
                                .font(.system(size: 56, weight: .bold))
                                .foregroundColor(.white)
                        )
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 8) {
                        Text(lawyer.nombre)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text(lawyer.especializacion)
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 32)
                .background(
                    LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .topLeading, endPoint: .bottomTrailing)
                )
                .foregroundColor(.white)
                .cornerRadius(25)

                // Lawyer details
                VStack(alignment: .leading, spacing: 20) {
                    Text("Información del Abogado")
                        .font(.title2)
                        .fontWeight(.bold)
                        .padding(.bottom, 8)
                    
                    detailRow(icon: "briefcase", title: "Especialidad", detail: lawyer.especializacion)
                    detailRow(icon: "book", title: "Maestría", detail: lawyer.maestria ?? "No disponible")
                    detailRow(icon: "clock", title: "Experiencia", detail: lawyer.experienciaProfesional)
                    detailRow(icon: "mappin", title: "Dirección", detail: formatAddress(lawyer.direccion))
                    detailRow(icon: "phone", title: "Teléfono", detail: lawyer.telefono)
                    detailRow(icon: "envelope", title: "Correo", detail: lawyer.correo)
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                // Statistics
                VStack(alignment: .leading, spacing: 16) {
                    Text("Estadísticas")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    HStack(spacing: 16) {
                        statisticCard(title: "Casos atendidos", value: "\(lawyer.casosAtendidos)", color: .blue)
                        statisticCard(title: "Casos ganados", value: "\(lawyer.casosSentenciaFavorable)", color: .green)
                        statisticCard(title: "Tasa de éxito", value: "\(calculateSuccessRate(lawyer))%", color: .purple)
                    }
                }
                .padding(24)
                .background(Color(.systemBackground))
                .cornerRadius(20)
                .shadow(color: Color.black.opacity(0.1), radius: 10, x: 0, y: 5)

                // Contact button
                Button(action: {
                    isContactExpanded.toggle()
                }) {
                    Text(isContactExpanded ? "Ocultar opciones de contacto" : "Contactar abogado")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                        .foregroundColor(.white)
                        .cornerRadius(15)
                        .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
                }

                if isContactExpanded {
                    VStack(spacing: 12) {
                        Button(action: {
                            // Action to call
                        }) {
                            Label("Llamar", systemImage: "phone")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.green.opacity(0.3), radius: 5, x: 0, y: 3)
                        }
                        
                        Button(action: {
                            // Action to send email
                        }) {
                            Label("Enviar correo", systemImage: "envelope")
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.orange)
                                .foregroundColor(.white)
                                .cornerRadius(15)
                                .shadow(color: Color.orange.opacity(0.3), radius: 5, x: 0, y: 3)
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
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                Text(detail)
                    .font(.body)
                    .foregroundColor(.primary)
            }
        }
    }
    
    private func statisticCard(title: String, value: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(15)
    }
    
    private func formatAddress(_ direccion: Lawyer.Direccion) -> String {
        return "\(direccion.calle), \(direccion.ciudad), \(direccion.estado) \(direccion.codigo_postal)"
    }
    
    private func calculateSuccessRate(_ lawyer: Lawyer) -> Int {
        guard lawyer.casosAtendidos > 0 else { return 0 }
        return Int((Double(lawyer.casosSentenciaFavorable) / Double(lawyer.casosAtendidos)) * 100)
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
                casosSentenciaFavorable: 80
            ))
        }
    }
}
