//
//  NotesSection.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//
// NotesSection.swift
import SwiftUI

struct NotesSection: View {
    @Binding var notes: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Notas")
                .font(.headline)
                .padding(.bottom, 5)
            TextEditor(text: $notes)
                .frame(height: 100)
                .padding(8)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        }
        .padding(.horizontal)
    }
}

struct NotesSection_Previews: PreviewProvider {
    @State static var sampleNotes = "Aquí puedes escribir tus notas..."

    static var previews: some View {
        NotesSection(notes: $sampleNotes)
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
