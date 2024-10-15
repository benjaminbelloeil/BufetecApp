import SwiftUI

struct EstudianteMainView: View {
    @State private var selectedTab = 0
    let userId: String

    var body: some View {
        TabView(selection: $selectedTab) {
            PerfilView(userId: userId)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Perfil")
                }
                .tag(0)
            
            CaseDetailView()
                .tabItem {
                    Image(systemName: "folder.fill")
                    Text("Mis Casos")
                }
                .tag(1)

            BibliotecaView()
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Biblioteca")
                }
                .tag(2)

            ClienteListView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                    Text("Clientes")
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

struct EstudianteMainView_Previews: PreviewProvider {
    static var previews: some View {
        EstudianteMainView(userId: "sampleUserId")
    }
}
