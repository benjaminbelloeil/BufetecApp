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
    @State private var showIntro: Bool = true
    
    var body: some View {
        ZStack {
            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                NavigationStack {
                    Login(showSignup: $showSignup, showIntro: $showIntro)
                        .navigationDestination(isPresented: $showSignup) {
                            Signup(showSignup: $showSignup)
                        }
                }
            }
        }
        .transition(.opacity)
        .animation(.easeInOut, value: showIntro)
    }
}

#Preview {
    ContentView()
}
