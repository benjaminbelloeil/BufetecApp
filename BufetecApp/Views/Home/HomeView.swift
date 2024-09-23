import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: AbogadoListView(lawyers: [
                    Lawyer(name: "Lic. Ana María López", specialty: "Derechos Procesal", caseType: "Problemas Familiares", imageName: "avatar1"),
                    Lawyer(name: "Lic. Juan Pérez", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2"),
                    Lawyer(name: "Lic. Moka Diaz", specialty: "Derecho Penal", caseType: "Casos Penales", imageName: "avatar2")
                ])) {
                    HStack {
                        Image("HomeIcons")
                            .resizable()
                            .frame(width: 70, height: 70)
                        Text("Abogados")
                            .font(.title)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .navigationTitle("Home")
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
