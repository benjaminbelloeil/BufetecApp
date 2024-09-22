//
//  CaseSummaryView..swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 22/09/24.
//

// CaseSummaryView.swift
import SwiftUI

struct CaseSummaryView: View {
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(.blue)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)

            VStack(alignment: .leading, spacing: 4) {
                Text("Mis casos, Lic. Jaime")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text("9 de abril de 2024")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
        }
        .padding(.horizontal)
    }
}

struct CaseSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        CaseSummaryView()
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
