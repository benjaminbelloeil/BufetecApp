import SwiftUI

struct ClienteMainView: View {
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
            
            BibliotecaView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Biblioteca")
                }
                .tag(1)


            ClienteCasoView(casoCliente: CasoCliente(name: "María González", caseType: "Divorcio", status: "Activo"))
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Mi Caso")
                }
                .tag(1)

            AbogadoListView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Abogados")
                }
                .tag(2)
        }
    }
}

struct ClienteMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteMainView(userId: "sampleUserId")
    }
}
