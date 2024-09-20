//
//  IntroView.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/17/24.
//
// IntroView.swift
import SwiftUI

struct IntroView: View {
    @State private var currentPage = 0
    @Binding var showIntro: Bool
    @Namespace private var animation
    
    var body: some View {
        ZStack {
            Color.white.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                HStack {
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                            if currentPage > 0 {
                                currentPage -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(hex: "3B5998"))
                            .font(.system(size: 24, weight: .bold))
                            .opacity(currentPage > 0 ? 1 : 0)
                    }
                    .disabled(currentPage == 0)
                    
                    Spacer()
                    
                    Button(action: {
                        showIntro = false
                    }) {
                        Image(systemName: "xmark")
                            .foregroundColor(Color(hex: "3B5998"))
                            .font(.system(size: 24, weight: .bold))
                    }
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                
                Spacer()
                
                TabView(selection: $currentPage) {
                    ForEach(Intro.introPages) { page in
                        VStack(spacing: 20) {
                            Text(page.title)
                                .font(.system(size: 40, weight: .bold))  // Increased size
                                .foregroundColor(Color(hex: "3B5998"))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .matchedGeometryEffect(id: "title\(page.tag)", in: animation)
                            
                            Text(page.description)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                                .matchedGeometryEffect(id: "description\(page.tag)", in: animation)
                            
                            Image(page.image)
                                .resizable()
                                .scaledToFit()  // Changed to scaledToFit
                                .frame(height: UIScreen.main.bounds.height * 0.4)  // Adjust height proportionally
                                .matchedGeometryEffect(id: "image\(page.tag)", in: animation)
                        }
                        .tag(page.tag)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                Spacer()
                
                VStack(spacing: 20) {
                    // Custom page indicator
                    HStack(spacing: 8) {
                        ForEach(0..<Intro.introPages.count, id: \.self) { index in
                            if index == currentPage {
                                Capsule()
                                    .fill(Color(hex: "8EC5FC"))
                                    .frame(width: 20, height: 8)
                            } else {
                                Circle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 8, height: 8)
                            }
                        }
                    }
                    .animation(.spring(), value: currentPage)
                    
                    // Continue/Start button
                    Button(action: {
                        withAnimation(.spring(response: 0.5, dampingFraction: 0.8, blendDuration: 0)) {
                            if currentPage < Intro.introPages.count - 1 {
                                currentPage += 1
                            } else {
                                showIntro = false
                            }
                        }
                    }) {
                        Text(currentPage == Intro.introPages.count - 1 ? "Empezar" : "Continuar")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(hex: "8EC5FC"))
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.bottom, 40)
            }
        }
    }
}

struct IntroView_Previews: PreviewProvider {
    static var previews: some View {
        IntroView(showIntro: .constant(true))
    }
}
