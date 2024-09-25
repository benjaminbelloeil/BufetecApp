import SwiftUI

struct ClienteCasoView: View {
    var casoCliente: CasoCliente
    @State private var showingDocuments = false
    @State private var showingContactForm = false

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                caseHeaderView
                caseProgressView
                caseDetailsView
                upcomingEventsView
                actionButtonsView
            }
            .padding()
        }
        .navigationTitle("Mi Caso")
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showingDocuments) {
            DocumentsView()
        }
        .sheet(isPresented: $showingContactForm) {
            ContactFormView()
        }
    }

    private var caseHeaderView: some View {
        VStack(spacing: 12) {
            Text(casoCliente.caseType)
                .font(.title2)
                .fontWeight(.bold)
            HStack {
                Label(casoCliente.status, systemImage: "circle.fill")
                    .font(.subheadline)
                    .foregroundColor(casoCliente.statusColor)
                Spacer()
                Text("Caso #12345")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var caseProgressView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Progreso del Caso")
                .font(.headline)
            ProgressView(value: 0.6)
                .accentColor(.blue)
            HStack {
                Text("Iniciado")
                    .font(.caption)
                Spacer()
                Text("En proceso")
                    .font(.caption)
                    .foregroundColor(.blue)
                Spacer()
                Text("Finalizado")
                    .font(.caption)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var caseDetailsView: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalles del Caso")
                .font(.headline)
            
            DetalleRow(title: "Abogado asignado", value: "Lic. Juan Pérez")
            DetalleRow(title: "Fecha de inicio", value: "01/01/2024")
            DetalleRow(title: "Tipo de caso", value: casoCliente.caseType)
            DetalleRow(title: "Estado actual", value: casoCliente.status)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var upcomingEventsView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Próximos Eventos")
                .font(.headline)
            
            ForEach(upcomingEvents, id: \.date) { event in
                HStack {
                    VStack(alignment: .leading) {
                        Text(event.title)
                            .font(.subheadline)
                            .fontWeight(.medium)
                        Text(event.date)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                }
                .padding(.vertical, 8)
            }
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private var actionButtonsView: some View {
        VStack(spacing: 12) {
            Button(action: { showingDocuments = true }) {
                Label("Ver Documentos", systemImage: "doc.text")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(PrimaryButtonStyle())

            Button(action: { showingContactForm = true }) {
                Label("Contactar Abogado", systemImage: "message")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(SecondaryButtonStyle())
        }
    }
}

struct DetalleRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .fontWeight(.medium)
        }
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color.blue.opacity(0.1))
            .foregroundColor(.blue)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.blue, lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}

struct DocumentsView: View {
    var body: some View {
        Text("Documents View")
    }
}

struct ContactFormView: View {
    var body: some View {
        Text("Contact Form View")
    }
}

struct CasoCliente {
    var name: String
    var caseType: String
    var status: String
    
    var statusColor: Color {
        switch status {
        case "Activo": return .green
        case "En espera": return .orange
        case "Finalizado": return .blue
        default: return .gray
        }
    }
}

let upcomingEvents = [
    (title: "Audiencia Preliminar", date: "15/03/2024"),
    (title: "Entrega de Documentos", date: "30/03/2024"),
    (title: "Reunión con Abogado", date: "10/04/2024")
]

struct ClienteCasoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ClienteCasoView(casoCliente: CasoCliente(name: "María González", caseType: "Divorcio", status: "Activo"))
        }
    }
}
