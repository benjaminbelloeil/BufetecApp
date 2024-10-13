import SwiftUI

struct ClienteCasoView: View {
    @ObservedObject var viewModel: CasoLegalViewModel
    var clienteId: String
    @State private var showingContactForm = false
    @State private var abogadoName: String = ""
    @StateObject private var lawyerModel = LawyerModel()
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let casoLegal = viewModel.caso {
                    caseHeaderView(casoLegal: casoLegal)
                    caseProgressView(casoLegal: casoLegal)
                    caseDetailsView(casoLegal: casoLegal)
                    actionButtonsView(casoLegal: casoLegal)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.title)
                        .foregroundColor(.red)
                } else {
                    Text("Cargando...")
                        .font(.title)
                }
            }
            .padding()
        }
        .navigationTitle("Mi Caso")
        .background(Color(.systemGroupedBackground))
        .sheet(isPresented: $showingContactForm) {
            ContactFormView()
        }
        .onAppear {
            Task {
                await viewModel.fetchCasoByClienteId(clienteId: clienteId)
                if let casoLegal = viewModel.caso {
                    if let nombre = await lawyerModel.fetchLawyerName(by: casoLegal.abogado_id) {
                        abogadoName = nombre
                    }
                }
            }
        }
    }

    private func caseHeaderView(casoLegal: CasoLegal) -> some View {
        VStack(spacing: 12) {
            Text(casoLegal.tipo_proceso)
                .font(.title)
                .fontWeight(.bold)
            Text(casoLegal.nombre_caso)
                .font(.title2)
        }
    }

    private func caseProgressView(casoLegal: CasoLegal) -> some View {
        VStack {
            Text("Progreso del Caso")
                .font(.headline)
            HStack {
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

    private func caseDetailsView(casoLegal: CasoLegal) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Detalles del Caso")
                .font(.headline)
            
            DetalleRow(title: "Abogado asignado", value: abogadoName)
            DetalleRow(title: "Tipo de caso", value: casoLegal.tipo_proceso)
            DetalleRow(title: "Estado actual", value: casoLegal.estado_proceso)
        }
        .padding()
        .background(Color(.secondarySystemBackground))
        .cornerRadius(12)
    }

    private func actionButtonsView(casoLegal: CasoLegal) -> some View {
        HStack {
            Button(action: {
                showingContactForm.toggle()
            }) {
                Text("Contactar")
            }
        }
    }
}

struct DetalleRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .fontWeight(.bold)
            Spacer()
            Text(value)
        }
    }
}

struct ContactFormView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contacto")) {
                    TextField("Nombre", text: .constant(""))
                    TextField("Correo", text: .constant(""))
                    TextField("Mensaje", text: .constant(""))
                }
            }
            .navigationTitle("Formulario de Contacto")
            .navigationBarItems(trailing: Button("Cerrar") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

struct ClienteCasoView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteCasoView(viewModel: CasoLegalViewModel(), clienteId: "670b3dd3defd761576ebb5e9")
    }
}
