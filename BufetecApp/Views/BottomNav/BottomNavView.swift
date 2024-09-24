import SwiftUI

struct BottomNav: View {
    @State private var selectedTab: Int = 0
    
    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                PerfilView()
                    .tabItem {
                        Image(systemName: "person.fill")
                        Text("Perfil")
                    }
                    .tag(0)
                
                ClienteListView()
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Clientes")
                    }
                    .tag(1)
                
                CaseDetailView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Mis Casos")
                    }
                    .tag(2)
                
                AbogadoListView(lawyers: [
                    Lawyer(name: "Lic. Ana María López", specialty: "Derechos Procesal", caseType: "Problemas Familiares", imageName: "avatar1"),
                    Lawyer(name: "Lic. Juan Pérez", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2"),
                    Lawyer(name: "Lic. Moka Diaz", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2")
                ])
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Abogados")
                    }
                    .tag(3)
            }
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = 0
                    }) {
                        VStack {
                            Image(systemName: "person.fill")
                            Text("Perfil")
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack {
                            Image(systemName: "person.3.fill")
                            Text("Clientes")
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 2
                    }) {
                        VStack {
                            Image(systemName: "list.bullet")
                            Text("Mis Casos")
                        }
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = 3
                    }) {
                        VStack {
                            Image(systemName: "person.3.fill")
                            Text("Abogados")
                        }
                    }
                    Spacer()
                }
                .padding()
                .background(Color.white)
                .shadow(radius: 10)
            }
        }
    }
}

struct BottomNav_Previews: PreviewProvider {
    static var previews: some View {
        BottomNav()
    }
}
