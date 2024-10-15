import SwiftUI

struct EstudianteMainView: View {
    @State private var selectedTab = 0
    @State private var showIntro: Bool = true
    let userId: String

    var body: some View {
        ZStack {
            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                TabView(selection: $selectedTab) {
                    PerfilView(userId: userId, showIntro: $showIntro)
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
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showIntro)
    }
}

#Preview {
    EstudianteMainView(userId: "670d6c4fc0cad37765214a64")
}