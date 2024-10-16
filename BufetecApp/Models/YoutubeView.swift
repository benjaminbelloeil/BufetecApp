//
//  YouTubeView.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 15/10/24.
//

import Foundation
import SwiftUI
import WebKit

struct YouTubeView: UIViewRepresentable {
    let videoID: String  // ID del video de YouTube

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Cargar el video usando el formato de incrustación de YouTube
        let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")!
        uiView.scrollView.isScrollEnabled = false  // Desactivar el scroll dentro del WebView
        uiView.load(URLRequest(url: youtubeURL))
    }
}
