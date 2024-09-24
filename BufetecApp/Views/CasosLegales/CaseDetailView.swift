// CaseDetailView.swift
import SwiftUI

struct CaseDetailView: View {
    // MARK: - State Properties
    @Environment(\.presentationMode) var presentationMode
    @State private var notes: String = ""

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header Section
                HeaderView {
                    presentationMode.wrappedValue.dismiss()
                } addCaseAction: {
                    // Acción de añadir caso
                    addCase()
                }

                // Case Summary Section
                CaseSummaryView()

                // Title Section
                Text("Asuntos")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                // Case Information
                CaseInformationView()

                // Download Button
                ActionButton(title: "Descargar", color: .blue, systemImage: "square.and.arrow.down") {
                    // Acción de descarga
                    downloadCase()
                }
                .padding(.horizontal)

                // Notes Section
                NotesSection(notes: $notes)
            }
            .padding()
        }
        .navigationTitle("Gestión de casos")
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Action Methods
    private func addCase() {
        // Implementar lógica para añadir un caso
        print("Añadir caso desde CaseDetailView")
    }

    private func downloadCase() {
        // Implementar lógica de descarga
        print("Descargar caso")
    }
}

struct CaseDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CaseDetailView()
        }
    }
}

