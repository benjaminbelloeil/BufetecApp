import SwiftUI

struct MainView: View {
    @State private var selectedTab: Tab = .profile
    @State private var userType: UserType = .abogado
    @State private var isLoading = true
    @State private var lawyers: [Lawyer] = []
    let userId: String

    enum Tab: Hashable {
        case profile, clients, cases, lawyers, Biblioteca
    }

    enum UserType {
        case cliente
        case estudiante
        case abogado
    }

    var body: some View {
        Group {
            if isLoading {
                ProgressView("Cargando...")
            } else {
                ZStack(alignment: .bottom) {
                    TabView(selection: $selectedTab) {
                        PerfilView()
                            .tabItem { EmptyView() }
                            .tag(Tab.profile)

                        if userType == .estudiante || userType == .abogado {
                            ClienteListView(clientes: [
                                Cliente(name: "María González", caseType: "Divorcio", status: "Activo"),
                                Cliente(name: "Carlos Rodríguez", caseType: "Custodia", status: "En espera"),
                                Cliente(name: "Ana Martínez", caseType: "Herencia", status: "Cerrado")
                            ])
                            .tabItem { EmptyView() }
                            .tag(Tab.clients)
                        }

                        if userType == .abogado {
                            CaseDetailView()
                                .tabItem { EmptyView() }
                                .tag(Tab.cases)
                        }
                        
                        if userType == .cliente {
                            ClienteCasoView(casoCliente: CasoCliente(name: "María González", caseType: "Divorcio", status: "Activo"))
                                .tabItem { EmptyView() }
                                .tag(Tab.cases)
                        }

                        if userType == .estudiante || userType == .abogado {
                            BibliotecaView()
                                .tabItem { EmptyView() }
                                .tag(Tab.Biblioteca)
                        }

                        AbogadoListView()
                            .tabItem { EmptyView() }
                            .tag(Tab.lawyers)
                    }

                    CustomTabBar(selectedTab: $selectedTab, userType: userType)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
        .onAppear {
            fetchUserData()
        }
    }

    private func fetchUserData() {
        guard let url = URL(string: "http://localhost:5001/user/\(userId)") else {
            print("URL inválida")
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    DispatchQueue.main.async {
                        if let rol = json["rol"] as? String {
                            switch rol {
                            case "cliente":
                                self.userType = .cliente
                            case "estudiante":
                                self.userType = .estudiante
                            case "abogado":
                                self.userType = .abogado
                            default:
                                print("Rol desconocido")
                            }
                        }
                        self.isLoading = false
                    }
                }
            } catch {
                print("Error al decodificar la respuesta: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.isLoading = false
                }
            }
        }.resume()
    }
}

struct TabItem: Identifiable {
    let id = UUID()
    let tab: MainView.Tab
    let icon: String
    let title: String
}

struct CustomTabBar: View {
    @Binding var selectedTab: MainView.Tab
    @Namespace private var namespace
    let userType: MainView.UserType

    var tabItems: [TabItem] {
        switch userType {
        case .cliente:
            return [
                TabItem(tab: .profile, icon: "person.circle.fill", title: "Perfil"),
                TabItem(tab: .cases, icon: "folder.fill", title: "Mi Caso"),
                TabItem(tab: .lawyers, icon: "briefcase.fill", title: "Abogados")
            ]
        case .estudiante:
            return [
                TabItem(tab: .profile, icon: "person.circle.fill", title: "Perfil"),
                TabItem(tab: .Biblioteca, icon: "books.vertical.fill", title: "Biblioteca"),
                TabItem(tab: .clients, icon: "person.3.fill", title: "Clientes"),
                TabItem(tab: .lawyers, icon: "briefcase.fill", title: "Abogados")
            ]
        case .abogado:
            return [
                TabItem(tab: .profile, icon: "person.circle.fill", title: "Perfil"),
                TabItem(tab: .clients, icon: "person.3.fill", title: "Clientes"),
                TabItem(tab: .cases, icon: "folder.fill", title: "Mis Casos"),
                TabItem(tab: .Biblioteca, icon: "books.vertical.fill", title: "Biblioteca"),
                TabItem(tab: .lawyers, icon: "briefcase.fill", title: "Abogados")
            ]
        }
    }

    var body: some View {
        HStack {
            ForEach(tabItems) { item in
                TabBarButton(
                    isSelected: selectedTab == item.tab,
                    item: item,
                    namespace: namespace,
                    onTap: {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = item.tab
                        }
                    }
                )
            }
        }
        .padding(.horizontal, 8)
        .padding(.top, 14)
        .padding(.bottom, 30)
        .background(
            Color(.systemBackground)
                .shadow(color: Color.black.opacity(0.1), radius: 16, x: 0, y: -5)
                .edgesIgnoringSafeArea(.bottom)
        )
        .overlay(
            Capsule()
                .fill(Color.blue.opacity(0.1))
                .frame(height: 4)
                .padding(.horizontal, 40)
                .offset(y: -14),
            alignment: .top
        )
    }
}

struct TabBarButton: View {
    let isSelected: Bool
    let item: TabItem
    let namespace: Namespace.ID
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 4) {
                ZStack {
                    if isSelected {
                        Capsule()
                            .fill(Color.blue.opacity(0.2))
                            .frame(height: 32)
                            .matchedGeometryEffect(id: "TabBackground", in: namespace)
                    }
                    
                    Image(systemName: item.icon)
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(isSelected ? .blue : .gray)
                        .frame(height: 32)
                }
                
                Text(item.title)
                    .font(.caption2)
                    .fontWeight(.medium)
                    .foregroundColor(isSelected ? .blue : .gray)
            }
        }
        .buttonStyle(PlainButtonStyle())
        .frame(maxWidth: .infinity)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(userId: "sampleUserId")
    }
}
