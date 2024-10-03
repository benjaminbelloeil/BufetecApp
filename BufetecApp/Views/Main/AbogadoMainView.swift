import SwiftUI

struct AbogadoMainView: View {
    @State private var selectedTab = 0
    let userId: String

    var body: some View {
        TabView(selection: $selectedTab) {
            PerfilView()
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Perfil")
                }
                .tag(0)

            ClienteListView(clientes: [
                Cliente(name: "María González", caseType: "Divorcio", status: "Activo"),
                Cliente(name: "Carlos Rodríguez", caseType: "Custodia", status: "En espera"),
                Cliente(name: "Ana Martínez", caseType: "Herencia", status: "Cerrado")
            ], casosLegales: [
                CasoLegal(
                    idCliente: UUID(),
                    idAbogado: UUID(),
                    nombre: "Caso 1",
                    expediente: "EXP123",
                    parteActora: "María González",
                    parteDemandada: "Juan Pérez",
                    estado: "Activo",
                    notas: "Notas del caso 1"
                ),
                CasoLegal(
                    idCliente: UUID(),
                    idAbogado: UUID(),
                    nombre: "Caso 2",
                    expediente: "EXP456",
                    parteActora: "Carlos Rodríguez",
                    parteDemandada: "Ana López",
                    estado: "En espera",
                    notas: "Notas del caso 2"
                ),
                CasoLegal(
                    idCliente: UUID(),
                    idAbogado: UUID(),
                    nombre: "Caso 3",
                    expediente: "EXP789",
                    parteActora: "Ana Martínez",
                    parteDemandada: "Luis García",
                    estado: "Cerrado",
                    notas: "Notas del caso 3"
                )
            ])
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Clientes")
            }
            .tag(1)

            CaseDetailView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Mis Casos")
                }
                .tag(2)

            BibliotecaView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Biblioteca")
                }
                .tag(3)

            AbogadoListView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Abogados")
                }
                .tag(4)
        }
    }
}

struct AbogadoMainView_Previews: PreviewProvider {
    static var previews: some View {
        AbogadoMainView(userId: "sampleUserId")
    }
}
