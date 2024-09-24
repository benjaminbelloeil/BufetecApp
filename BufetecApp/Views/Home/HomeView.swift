import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            TabView {
                ClienteListView()
                    .tabItem {
                        Image(systemName: "person.2.fill")
                        Text("Clientes")
                    }
                
                CaseDetailView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Mis Casos")
                    }
                
                AbogadoListView(lawyers: [
                    Lawyer(name: "Lic. Ana María López", specialty: "Derechos Procesal", caseType: "Problemas Familiares", imageName: "avatar1"),
                    Lawyer(name: "Lic. Juan Pérez", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2"),
                    Lawyer(name: "Lic. Moka Diaz", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2")
                ])
                    .tabItem {
                        Image(systemName: "person.3.fill")
                        Text("Abogados")
                    }
            }
        }
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

