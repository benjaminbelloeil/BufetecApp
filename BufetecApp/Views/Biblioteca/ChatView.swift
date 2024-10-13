import SwiftUI

struct ChatView: View {
    @ObservedObject var viewModel: ChatViewModel
    var documentId: String
    var userId: String
    @State private var scrollProxy: ScrollViewProxy?

    var body: some View {
        VStack(spacing: 0) {
            // Display messages
            ScrollView {
                ScrollViewReader { scrollView in
                    LazyVStack(spacing: 12) {
                        ForEach(viewModel.chat?.messages ?? []) { message in
                            MessageBubble(message: message)
                        }
                    }
                    .padding(.vertical)
                    .onChange(of: viewModel.chat?.messages.count) { oldCount, newCount in
                        if oldCount != newCount {
                            withAnimation {
                                scrollView.scrollTo(viewModel.chat?.messages.last?.id, anchor: .bottom)
                            }
                        }
                    }
                    .onAppear {
                        scrollProxy = scrollView
                    }
                }
            }
            .background(Color(.systemBackground))

            // Text input field for sending messages
            HStack(spacing: 12) {
                TextField("Escribe un mensaje...", text: $viewModel.newMessage)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                    .frame(minHeight: 40)

                Button(action: {
                    viewModel.sendMessage()
                    scrollToBottom()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(Color.blue)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(Color(.systemBackground))
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: -5)
        }
        .navigationTitle("Chat")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                VStack {
                    Text("Chat")
                        .font(.headline)
                    Text("Documento #\(documentId)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .onAppear {
            viewModel.loadOrCreateChat(documentId: documentId, userId: userId)
        }
    }

    private func scrollToBottom() {
        withAnimation {
            scrollProxy?.scrollTo(viewModel.chat?.messages.last?.id, anchor: .bottom)
        }
    }
}

struct MessageBubble: View {
    var message: Message
    
    private var isUser: Bool {
        message.sender == "User"
    }

    var body: some View {
        HStack {
            if isUser { Spacer(minLength: 50) }
            
            VStack(alignment: isUser ? .trailing : .leading, spacing: 4) {
                Text(message.message)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(isUser ? Color.blue : Color(.systemGray6))
                    .foregroundColor(isUser ? .white : .primary)
                    .cornerRadius(10)
                
                Text(formatTimestamp(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: 300, alignment: isUser ? .trailing : .leading)
            
            if !isUser { Spacer(minLength: 50) }
        }
        .padding(.horizontal)
    }
    
    private func formatTimestamp(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        let dummyMessages = [
            Message(sender: "User", message: "¿Se menciona algo sobre divorcios?", timestamp: Date()),
            Message(sender: "Assistant", message: "El Artículo 130 de la Constitución Política de los Estados Unidos Mexicanos establece que el matrimonio es un contrato civil. Las leyes civiles establecerán las causas de divorcio y determinarán las formalidades para la celebración del matrimonio y los requisitos para su disolución. Es importante consultar las leyes específicas de cada estado, ya que pueden variar.", timestamp: Date()),
            Message(sender: "User", message: "Gracias por la información. ¿Podrías explicarme más sobre el proceso de divorcio?", timestamp: Date()),
            Message(sender: "Assistant", message: "Por supuesto. El proceso de divorcio en México puede ser de dos tipos: por mutuo consentimiento o contencioso. El divorcio por mutuo consentimiento es más rápido y menos costoso, ya que ambas partes están de acuerdo. El divorcio contencioso ocurre cuando una de las partes no está de acuerdo o hay disputas sobre la división de bienes o la custodia de los hijos. En general, el proceso incluye:\n\n1. Presentación de la demanda de divorcio\n2. Notificación a la otra parte\n3. Respuesta a la demanda\n4. Audiencias y negociaciones\n5. Sentencia de divorcio\n\nEs recomendable contar con la asesoría de un abogado especializado en derecho familiar para guiarte durante todo el proceso.", timestamp: Date())
        ]
        
        let dummyChat = Chat(id: "1", chatId: "1", userId: "1", documentId: "1", assistantId: "assistant123", messages: dummyMessages)
        
        let chatViewModel = ChatViewModel()
        chatViewModel.chat = dummyChat
        
        return NavigationStack {
            ChatView(viewModel: chatViewModel, documentId: "1", userId: "1")
        }
    }
}

