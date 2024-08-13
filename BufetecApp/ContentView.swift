//
//  ContentView.swift
//  Buffetec
//
//  Created by Benjamin Belloeil on 8/12/24.
//

import SwiftUI

struct ContentView: View {
    /// View Properties
    @State private var showSignup: Bool = false
    var body: some View {
        NavigationStack {
            Login(showSignup: $showSignup)
                .navigationDestination(isPresented: $showSignup) {
                    Signup(showSignup: $showSignup)
            }
        }
        .overlay {
            /// Bounce animation
            if #available(iOS 17, *) {
                CircleView()
                    .animation(.smooth(duration: 0.45, extraBounce: 0), value: showSignup)
            } else {
                CircleView()
                    .animation(.easeInOut(duration: 0.3), value: showSignup)
            }
        }
    }
    
    /// Moving blurred background
    @ViewBuilder
    func CircleView() -> some View {
        Circle()
            .fill(LinearGradient(colors: [.blue, .cyan, .teal], startPoint: .top, endPoint: .bottom))
            .frame(width: 200, height: 200)
            /// Moving when the signup pages loads/dissmises
            .offset(x: showSignup ? 90 : -90, y: -90)
            .blur(radius: 15)
            .hSpacing(showSignup ? .trailing : .leading)
            .vSpacing(.top)
    }
}

#Preview {
    ContentView()
}
