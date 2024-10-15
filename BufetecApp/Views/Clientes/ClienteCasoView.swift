import SwiftUI

struct ClienteCasoView: View {
    @ObservedObject var viewModel: CasoLegalViewModel
    var userId: String
    @State private var clienteId: String = ""
    @State private var showingContactForm = false
    @State private var abogadoName: String = ""
    @StateObject private var lawyerModel = LawyerModel()

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                if let casoLegal = viewModel.caso {
                    caseHeaderView(casoLegal: casoLegal)
                    caseDetailsView(casoLegal: casoLegal)
                    actionButtonsView(casoLegal: casoLegal)
                } else if let errorMessage = viewModel.errorMessage {
                    errorView(message: errorMessage)
                } else {
                    loadingView()
                }
            }
            .padding()
        }
        .navigationTitle("Mi Caso")
        .background(Color(.systemGroupedBackground).edgesIgnoringSafeArea(.all))
        .sheet(isPresented: $showingContactForm) {
            ContactFormView()
        }
        .onAppear {
            Task {
                await viewModel.fetchClienteIdByUserId(userId: userId)
                print("User ID: \(userId)")
                if let fetchedClienteId = viewModel.clienteId {
                    clienteId = fetchedClienteId
                    print("Cliente ID: \(clienteId)")
                    await viewModel.fetchCasoByClienteId(clienteId: clienteId)
                    if let casoLegal = viewModel.caso {
                        print("Caso ID: \(casoLegal.id)")
                        if let nombre = await lawyerModel.fetchLawyerName(by: casoLegal.abogado_id) {
                            print("Abogado: \(nombre)")
                            abogadoName = nombre
                        }
                    }
                }
            }
        }
    }

    private func caseHeaderView(casoLegal: CasoLegal) -> some View {
        VStack(spacing: 16) {
            Text(casoLegal.nombre_caso)
                .font(.system(size: 28, weight: .bold))
            Text(casoLegal.tipo_proceso)
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
            statusBadge(status: casoLegal.estado_proceso)
        }
        .padding(24)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
    }

    private func statusBadge(status: String) -> some View {
        Text(status)
            .font(.system(size: 14, weight: .semibold))
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .background(statusColor(for: status).opacity(0.2))
            .foregroundColor(statusColor(for: status))
            .cornerRadius(20)
    }

    private func statusColor(for status: String) -> Color {
        switch status.lowercased() {
        case "en proceso":
            return .blue
        case "finalizado":
            return .green
        default:
            return .orange
        }
    }

    private func caseDetailsView(casoLegal: CasoLegal) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Detalles del Caso")
                .font(.system(size: 22, weight: .bold))
                .padding(.bottom, 8)
            
            DetalleRow(title: "Abogado asignado", value: abogadoName)
            DetalleRow(title: "Tipo de caso", value: casoLegal.tipo_proceso)
            DetalleRow(title: "Estado actual", value: casoLegal.estado_proceso)
        }
        .padding(24)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 10, x: 0, y: 5)
    }

    private func actionButtonsView(casoLegal: CasoLegal) -> some View {
        Button(action: {
            showingContactForm.toggle()
        }) {
            HStack {
                Image(systemName: "message.fill")
                Text("Contactar Abogado")
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(15)
            .shadow(color: Color.blue.opacity(0.3), radius: 5, x: 0, y: 3)
        }
    }

    private func errorView(message: String) -> some View {
        Text(message)
            .font(.system(size: 18, weight: .medium))
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(15)
    }

    private func loadingView() -> some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("Cargando...")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

struct DetalleRow: View {
    var title: String
    var value: String

    var body: some View {
        HStack {
            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .semibold))
        }
    }
}

struct ContactFormView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Contacto").textCase(.uppercase)) {
                    TextField("Nombre", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    TextField("Correo", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.emailAddress)
                    TextField("Mensaje", text: .constant(""))
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            .navigationTitle("Formulario de Contacto")
            .navigationBarItems(trailing: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .imageScale(.large)
            })
        }
    }
}

struct ClienteCasoView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteCasoView(viewModel: CasoLegalViewModel(), userId: "sampleUserId")
    }
}
