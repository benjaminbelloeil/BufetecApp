import SwiftUI

enum UserType {
    case client
    case lawyer
    case other
}

struct QuestionView: View {
    @Binding var showQuestions: Bool
    @State private var userType: UserType?
    @State private var currentQuestion = 1
    @State private var selectedProblem: String?
    @State private var identification = ""
    @State private var password = ""
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            HStack {
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        if currentQuestion > 1 {
                            currentQuestion -= 1
                        } else {
                            showQuestions = false
                        }
                    }
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                        .padding()
                }
                Spacer()
                Text("Preguntas Iniciales")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button(action: {
                    showQuestions = false
                }) {
                    Image(systemName: "xmark")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
            .padding(.top, 50)
            
            // Animated Progress bar
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 8)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: geometry.size.width * CGFloat(currentQuestion) / CGFloat(totalQuestions), height: 8)
                        .animation(.spring(response: 0.5, dampingFraction: 0.7, blendDuration: 0), value: currentQuestion)
                }
                .cornerRadius(4)
            }
            .frame(height: 8)
            .padding(.horizontal)
            
            Text("\(currentQuestion)/\(totalQuestions)")
                .font(.caption)
                .foregroundColor(.gray)
            
            Spacer()
                .frame(height: 20)
            
            // Questions with transition
            ZStack {
                if currentQuestion == 1 {
                    roleSelectionView.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if userType == .client {
                    clientQuestionView.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                } else if userType == .lawyer {
                    lawyerQuestionView.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
                }
            }
            .animation(.easeInOut(duration: 0.3), value: currentQuestion)
            
            Spacer()
            
            // Continue Button
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    if currentQuestion < totalQuestions {
                        currentQuestion += 1
                    } else {
                        // Handle completion
                        showQuestions = false
                    }
                }
            }) {
                Text("Continuar")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(canProceed ? Color.blue : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 50)
            .disabled(!canProceed)
        }
        .background(Color(UIColor.systemBackground))
        .edgesIgnoringSafeArea(.all)
    }
    
    var roleSelectionView: some View {
        VStack(spacing: 15) {
            Text("Por favor, seleccione su rol:\n¿Es usted cliente, abogado u otro?")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ForEach(["Cliente", "Abogado", "Otro"], id: \.self) { option in
                OptionRow(option: String(option.first!),
                          text: option,
                          isSelected: userType == UserType(rawValue: option.lowercased())) {
                    userType = UserType(rawValue: option.lowercased())
                }
            }
        }
        .padding()
    }
    
    var clientQuestionView: some View {
        VStack(spacing: 15) {
            Text("¿Qué problema está enfrentando actualmente? Por favor, seleccione una opción.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ForEach(["Asuntos de Familia y Matrimonio", "Custodia y Tutela de Menores", "Herencias y Sucesiones", "Identidad y Registro Civil", "Autorizaciones Legales y Apoyo"], id: \.self) { problem in
                OptionRow(option: String(problem.first!),
                          text: problem,
                          isSelected: selectedProblem == problem) {
                    selectedProblem = problem
                }
            }
        }
        .padding()
    }
    
    var lawyerQuestionView: some View {
        VStack(spacing: 20) {
            Text("Por favor, ingrese su Identificación y Contraseña.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            VStack(spacing: 15) {
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.gray)
                    TextField("Identificación", text: $identification)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                    SecureField("Contraseña", text: $password)
                }
                .padding()
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
            }
            .padding()
            .background(Color.white)
            .cornerRadius(15)
            .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        }
        .padding()
    }
    
    var totalQuestions: Int {
        switch userType {
        case .client:
            return 3
        case .lawyer:
            return 2
        case .other, .none:
            return 1
        }
    }
    
    var canProceed: Bool {
        switch currentQuestion {
        case 1:
            return userType != nil
        case 2:
            if userType == .client {
                return selectedProblem != nil
            } else if userType == .lawyer {
                return !identification.isEmpty && !password.isEmpty
            }
        default:
            return true
        }
        return false
    }
}

struct OptionRow: View {
    var option: String
    var text: String
    var isSelected: Bool
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(option)
                    .frame(width: 36, height: 36)
                    .background(isSelected ? Color.blue : Color(UIColor.systemGray5))
                    .foregroundColor(isSelected ? .white : .black)
                    .cornerRadius(18)
                    .font(.headline)
                
                Text(text)
                    .foregroundColor(isSelected ? Color.blue : Color.primary)
                    .font(.system(size: 17, weight: .regular))
                Spacer()
            }
            .padding()
            .background(isSelected ? Color.blue.opacity(0.1) : Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
        }
    }
}

extension UserType {
    init?(rawValue: String) {
        switch rawValue {
        case "cliente":
            self = .client
        case "abogado":
            self = .lawyer
        case "otro":
            self = .other
        default:
            return nil
        }
    }
}
