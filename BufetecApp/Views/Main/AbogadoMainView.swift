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
