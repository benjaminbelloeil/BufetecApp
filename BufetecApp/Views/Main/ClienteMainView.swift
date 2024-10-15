import SwiftUI

struct ClienteMainView: View {
    @State private var selectedTab = 0
    @State private var showIntro: Bool = true
    let userId: String
    @StateObject private var viewModel = CasoLegalViewModel()
    
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
                    
                    BibliotecaView()
                        .tabItem {
                            Image(systemName: "books.vertical.fill")
                            Text("Biblioteca")
                        }
                        .tag(1)

                    ClienteCasoView(viewModel: viewModel, userId: userId)
                        .tabItem {
                            Image(systemName: "folder.fill")
                            Text("Mi Caso")
                        }
                        .tag(2)

                    AbogadoListView()
                        .tabItem {
                            Image(systemName: "briefcase.fill")
                            Text("Abogados")
                        }
                        .tag(3)
                }
                .transition(.opacity)
                .animation(.easeInOut, value: showIntro)
            }
        }
    }
}

struct ClienteMainView_Previews: PreviewProvider {
    static var previews: some View {
        ClienteMainView(userId: "sampleUserId")
    }
}
