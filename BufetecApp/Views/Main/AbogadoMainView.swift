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

            ClienteListView(
                casosLegales: [
                    CasoLegal(
                        id: "1",
                        idCliente: "1",
                        idAbogado: "1",
                        nombre: "Divorcio",
                        expediente: "EXP123",
                        parteActora: "John Doe",
                        parteDemandada: "Jane Doe",
                        estado: "Activo",
                        notas: "Notas del caso de divorcio",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    ),
                    CasoLegal(
                        id: "2",
                        idCliente: "2",
                        idAbogado: "2",
                        nombre: "Custodia",
                        expediente: "EXP456",
                        parteActora: "Alice Smith",
                        parteDemandada: "Bob Smith",
                        estado: "En espera",
                        notas: "Notas del caso de custodia",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    ),
                    CasoLegal(
                        id: "3",
                        idCliente: "3",
                        idAbogado: "3",
                        nombre: "Herencia",
                        expediente: "EXP789",
                        parteActora: "Charlie Brown",
                        parteDemandada: "Lucy Brown",
                        estado: "Cerrado",
                        notas: "Notas del caso de herencia",
                        proximaAudiencia: Date(),
                        fechaInicio: Date(),
                        imageName: "url"
                    )
                ]
            )
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
