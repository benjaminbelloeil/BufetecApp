//
//  Chat.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 24/09/24.
//

import Foundation

struct Message: Identifiable {
    var id = UUID()
    var sender: String
    var message: String
    var timestamp: Date
}

struct Chat: Identifiable {
    var id: String
    var chatId: String
    var userId: String
    var documentId: String
    var assistantId: String
    var messages: [Message]
}
