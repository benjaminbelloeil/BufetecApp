import SwiftUI

struct EstudianteMainView: View {
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

            ClienteListView(clientes: [
                Cliente(name: "María González", caseType: "Divorcio", status: "Activo"),
                Cliente(name: "Carlos Rodríguez", caseType: "Custodia", status: "En espera"),
                Cliente(name: "Ana Martínez", caseType: "Herencia", status: "Cerrado")
            ])
            .tabItem {
                Image(systemName: "person.3.fill")
                Text("Clientes")
            }
            .tag(2)

            AbogadoListView()
                .tabItem {
                    Image(systemName: "briefcase.fill")
                    Text("Abogados")
                }
                .tag(3)
        }
    }
}

struct EstudianteMainView_Previews: PreviewProvider {
    static var previews: some View {
        EstudianteMainView(userId: "sampleUserId")
    }
}
