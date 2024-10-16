//
//  Video.swift
//  BufetecApp
//
//  Created by Edsel Cisneros Bautista on 15/10/24.
//
import Foundation

struct Video: Identifiable {
    let id: UUID
    let titulo: String
    let descripcion: String
    let thumbnailURL: String
    let videoID: String  // Cambié videoURL por videoID para incrustar videos de YouTube
    let duracion: String
}
