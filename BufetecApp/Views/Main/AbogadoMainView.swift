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
                clientes: [
                    Cliente(
                        user_id: "1",
                        nombre: "María González",
                        contacto: "Contacto 1",
                        proxima_audiencia: Date(),
                        telefono: "123-456-7890",
                        correo: "maria@example.com",
                        fecha_inicio: Date(),
                        direccion: Cliente.Direccion(
                            calle: "Calle 1",
                            ciudad: "Ciudad 1",
                            estado: "Estado 1",
                            codigo_postal: "12345"
                        ),
                        imageName: "maria"
                    ),
                    Cliente(
                        user_id: "2",
                        nombre: "Carlos Rodríguez",
                        contacto: "Contacto 2",
                        proxima_audiencia: Date(),
                        telefono: "987-654-3210",
                        correo: "carlos@example.com",
                        fecha_inicio: Date(),
                        direccion: Cliente.Direccion(
                            calle: "Calle 2",
                            ciudad: "Ciudad 2",
                            estado: "Estado 2",
                            codigo_postal: "54321"
                        ),
                        imageName: "carlos"
                    ),
                    Cliente(
                        user_id: "3",
                        nombre: "Ana Martínez",
                        contacto: "Contacto 3",
                        proxima_audiencia: Date(),
                        telefono: "555-555-5555",
                        correo: "ana@example.com",
                        fecha_inicio: Date(),
                        direccion: Cliente.Direccion(
                            calle: "Calle 3",
                            ciudad: "Ciudad 3",
                            estado: "Estado 3",
                            codigo_postal: "67890"
                        ),
                        imageName: "ana"
                    )
                ],
                casosLegales: [
                    CasoLegal(
                        id: UUID(),
                        idCliente: UUID(), // Provide appropriate UUID
                        idAbogado: UUID(), // Provide appropriate UUID
                        nombre: "Divorcio",
                        expediente: "EXP123",
                        parteActora: "John Doe",
                        parteDemandada: "Jane Doe",
                        estado: "Activo",
                        notas: "Notas del caso de divorcio"
                    ),
                    CasoLegal(
                        id: UUID(),
                        idCliente: UUID(), // Provide appropriate UUID
                        idAbogado: UUID(), // Provide appropriate UUID
                        nombre: "Custodia",
                        expediente: "EXP456",
                        parteActora: "Alice Smith",
                        parteDemandada: "Bob Smith",
                        estado: "En espera",
                        notas: "Notas del caso de custodia"
                    ),
                    CasoLegal(
                        id: UUID(),
                        idCliente: UUID(), // Provide appropriate UUID
                        idAbogado: UUID(), // Provide appropriate UUID
                        nombre: "Herencia",
                        expediente: "EXP789",
                        parteActora: "Charlie Brown",
                        parteDemandada: "Lucy Brown",
                        estado: "Cerrado",
                        notas: "Notas del caso de herencia"
                    )
                ]
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
