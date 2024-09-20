//
//  Intro.swift
//  BufetecApp
//
//  Created by Benjamin Belloeil on 9/17/24.
//

import Foundation

struct Intro: Identifiable {
    let id = UUID()
    var title: String
    var description: String
    var image: String
    var buttonText: String
    var tag: Int
    
    static var introPages: [Intro] = [
        Intro(title: "¡BufeTec les da la bienvenida!",
              description: "BufeTec ofrece asesoría jurídica gratuita y trámites notariales accesibles con la calidad que necesitas. Con el apoyo de profesionales y estudiantes del Tec de Monterrey, brindamos servicios legales confiables a la comunidad.",
              image: "intro1",
              buttonText: "Continuar",
              tag: 0),
        Intro(title: "Misión",
              description: "Proporcionar asistencia legal gratuita y de alta calidad a personas de bajos recursos, defendiendo sus derechos y guiándolas en sus procesos legales, con un enfoque en la justicia social y el bienestar de la comunidad.",
              image: "intro2",
              buttonText: "Continuar",
              tag: 1),
        Intro(title: "Visión",
              description: "Ser reconocidos como el principal centro jurídico en Nuevo León, proporcionando acceso equitativo a la justicia y promoviendo un cambio positivo en la vida de personas de bajos recursos a través de un apoyo legal integral y de calidad.",
              image: "intro3",
              buttonText: "Empezar",
              tag: 2),
    ]
}
