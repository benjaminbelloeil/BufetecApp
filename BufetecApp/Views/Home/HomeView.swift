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
                HStack(spacing: 0) {
                    Image("HomeIcons")
                      .resizable()
                      .frame(width: 66, height: 66)
                    Text("Abogados")
                        .font(.title)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                    }
                }

                NavigationLink(destination: NewCaseView()) {
                    HStack(spacing: 0) {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 48, height: 50)
                        Text("Nuevo Caso")
                            .font(.title)
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                    }
                }


            }
            .navigationTitle("Home")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
