//
//  ChatViewModel.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 25/09/24.
//

import Foundation
import Combine

class ChatViewModel: ObservableObject {
    @Published var chat: Chat?
    @Published var newMessage: String = ""

    private var cancellables = Set<AnyCancellable>()

    // Dummy data for chat messages
    let sampleMessages = [
        Message(sender: "User", message: "¿Se menciona algo sobre divorcios?", timestamp: Date()),
        Message(sender: "Assistant", message: "El Artículo 130 de la Constitución...", timestamp: Date())
    ]

    // Function to either fetch or create a new chat for a document and user
    func loadOrCreateChat(documentId: String, userId: String) {
        // Check if chat already exists (dummy logic for now)
        let newChat = Chat(id: UUID().uuidString, chatId: UUID().uuidString, userId: userId, documentId: documentId, assistantId: "assistant123", messages: sampleMessages)
        self.chat = newChat
        //        if let existingChat = findChat(documentId: documentId, userId: userId) {
//            self.chat = existingChat
//        } else {
//            createNewChat(documentId: documentId, userId: userId)
//        }
    }

    // Dummy function to simulate finding an existing chat
    private func findChat(documentId: String, userId: String) -> Chat? {
        // For now, return nil to simulate no existing chat
        return nil
    }

    // Function to create a new chat
    private func createNewChat(documentId: String, userId: String) {
        let newChat = Chat(id: UUID().uuidString, chatId: UUID().uuidString, userId: userId, documentId: documentId, assistantId: "assistant123", messages: sampleMessages)
        self.chat = newChat
    }

    // Simulate sending a message via an API endpoint
    func sendMessage() {
        guard !newMessage.isEmpty, let chat = chat else { return }

        // Simulate adding a new message to the chat
        let userMessage = Message(sender: "User", message: newMessage, timestamp: Date())
        self.chat?.messages.append(userMessage)

        // Reset the new message text field
        newMessage = ""

        // Simulate API call to send the message and get a response
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let assistantMessage = Message(sender: "Assistant", message: "Aquí está la respuesta del asistente.", timestamp: Date())
            self.chat?.messages.append(assistantMessage)
        }
    }
}
