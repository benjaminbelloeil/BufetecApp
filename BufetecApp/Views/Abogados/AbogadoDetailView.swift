import SwiftUI

struct AbogadoDetailView: View {
    var lawyer: Lawyer
    @State private var searchText = ""
    @State private var isContactExpanded = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Lawyer image and name
                VStack {
                    Image(lawyer.imageName)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .shadow(radius: 10)
                    
                    Text(lawyer.name)
                        .font(.title)
                        .fontWeight(.bold)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)

                // Lawyer details
                VStack(alignment: .leading, spacing: 15) {
                    detailRow(icon: "briefcase", title: "Especialidad", detail: lawyer.specialty)
                    detailRow(icon: "doc.text", title: "Casos Asociados", detail: lawyer.caseType)
                    detailRow(icon: "mappin", title: "Dirección", detail: "Zona Tec")
                    detailRow(icon: "phone", title: "Teléfono", detail: "XXXXXXXXXX")
                    detailRow(icon: "envelope", title: "Correo", detail: "abogado@example.com")
                    detailRow(icon: "chart.bar", title: "Casos atendidos", detail: "7")
                    detailRow(icon: "checkmark.seal", title: "Tasa de éxito", detail: "78%")
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(15)

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
        .searchable(text: $searchText, prompt: "Buscar en el perfil...")
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
            }
        }
    }
}

struct AbogadoDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            AbogadoDetailView(lawyer: Lawyer(
                name: "Lic. Ana María López",
                specialty: "Maestría en Derecho Procesal",
                caseType: "Problemas Familiares",
                imageName: "avatar1"
            ))
        }
    }
}
