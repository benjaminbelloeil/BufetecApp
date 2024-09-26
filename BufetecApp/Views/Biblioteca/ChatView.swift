//
//  ChatView.swift
//  BufetecApp
//
//  Created by David Balleza Ayala on 25/09/24.
//

import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    var documentId: String
    var userId: String

    var body: some View {
        VStack {
            // Display messages
            ScrollView {
                ScrollViewReader { scrollView in
                    VStack {
                        ForEach(viewModel.chat?.messages ?? []) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .onChange(of: viewModel.chat?.messages.count) { oldCount, newCount in
                        if oldCount != newCount {
                            withAnimation {
                                scrollView.scrollTo(viewModel.chat?.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                }
            }
            .background(Color(.systemGray6))

            // Text input field for sending messages
            HStack {
                TextField("Escribe un mensaje...", text: $viewModel.newMessage)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .frame(minHeight: 40)

                Button(action: {
                    viewModel.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.blue)
                        .padding(.horizontal)
                }
            }
            .padding()
        }
        .navigationTitle("Chat")
        .onAppear {
            viewModel.loadOrCreateChat(documentId: documentId, userId: userId)
        }
    }
}

struct MessageBubble: View {
    var message: Message

    var body: some View {
        HStack {
            if message.sender == "User" {
                Spacer()
                Text(message.message)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .frame(maxWidth: 300, alignment: .trailing)
            } else {
                Text(message.message)
                    .padding()
                    .background(Color.gray.opacity(0.2))
                    .foregroundColor(.black)
                    .cornerRadius(10)
                    .frame(maxWidth: 300, alignment: .leading)
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
}

#Preview {
    let dummyMessages = [
        Message(sender: "User", message: "¿Se menciona algo sobre divorcios?", timestamp: Date()),
        Message(sender: "Assistant", message: "El Artículo 130 de la Constitución...", timestamp: Date()),
        Message(sender: "User", message: "Gracias por la información.", timestamp: Date())
    ]
    
    let dummyChat = Chat(id: "1", chatId: "1", userId: "1", documentId: "1", assistantId: "assistant123", messages: dummyMessages)
    
    let chatViewModel = ChatViewModel()
    chatViewModel.chat = dummyChat
    
    return NavigationStack {
        ChatView(viewModel: chatViewModel, documentId: "1", userId: "1")
    }
}
