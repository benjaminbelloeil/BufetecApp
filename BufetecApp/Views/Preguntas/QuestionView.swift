//
//  QuestionsView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/22/24.
//

import SwiftUI

struct QuestionView: View {
    @State private var selectedOption: String? = nil

    var body: some View {
        VStack {
            Text("¿Es usted cliente, abogado u otro?")
                .font(.title2)

            // Sample question options
            Picker("Select your role", selection: $selectedOption) {
                Text("Cliente").tag("A")
                Text("Abogado").tag("B")
                Text("Otro").tag("C")
            }
            .pickerStyle(.segmented)
            .padding()

            Button(action: {
                // Navigate to the next question or submit response
            }) {
                Text("Continuar")
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        }
        .padding()
    }
}

struct QuestionView_Previews: PreviewProvider {
    static var previews: some View {
        QuestionView()
    }
}
