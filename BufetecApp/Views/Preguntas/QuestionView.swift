import SwiftUI

enum UserType {
    case client
    case lawyer
    case student
}

struct QuestionView: View {
    @Binding var showQuestions: Bool
    @State private var userType: UserType?
    @State private var currentQuestion = 1
    @State private var selectedProblem: String?
    @State private var identification = ""
    @State private var password = ""
    @State private var matricula = ""
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
                } else if userType == .student {
                    studentQuestionView.transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
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
            Text("Por favor, seleccione su rol:\n¿Es usted cliente, abogado o estudiante?")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            ForEach(Array(zip(["Cliente", "Abogado", "Estudiante"].indices, ["Cliente", "Abogado", "Estudiante"])), id: \.0) { index, option in
                OptionRow(option: String(Character(UnicodeScalar(65 + index)!)),
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
            
            ForEach(Array(zip(["Asuntos de Familia y Matrimonio", "Custodia y Tutela de Menores", "Herencias y Sucesiones", "Identidad y Registro Civil", "Autorizaciones Legales y Apoyo"].indices, ["Asuntos de Familia y Matrimonio", "Custodia y Tutela de Menores", "Herencias y Sucesiones", "Identidad y Registro Civil", "Autorizaciones Legales y Apoyo"])), id: \.0) { index, problem in
                OptionRow(option: String(Character(UnicodeScalar(65 + index)!)),
                          text: problem,
                          isSelected: selectedProblem == problem) {
                    selectedProblem = problem
                }
            }
        }
        .padding()
    }
    
    var lawyerQuestionView: some View {
        VStack(spacing: 25) {
            Text("Por favor, ingrese su Identificación y Contraseña.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Image(systemName: "person.text.rectangle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "person.circle")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                        .frame(width: 30)
                    TextField("", text: $identification)
                        .placeholder(when: identification.isEmpty) {
                            Text("Identificación").foregroundColor(.gray.opacity(0.7))
                        }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                        .frame(width: 30)
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Contraseña").foregroundColor(.gray.opacity(0.7))
                        }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var studentQuestionView: some View {
        VStack(spacing: 25) {
            Text("Por favor, ingrese su Matrícula y Contraseña.")
                .font(.title3)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Image(systemName: "graduationcap")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 100)
                .foregroundColor(.blue)
                .padding(.bottom, 20)
            
            VStack(spacing: 20) {
                HStack {
                    Image(systemName: "number")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                        .frame(width: 30)
                    TextField("", text: $matricula)
                        .placeholder(when: matricula.isEmpty) {
                            Text("Matrícula").foregroundColor(.gray.opacity(0.7))
                        }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                
                HStack {
                    Image(systemName: "lock")
                        .foregroundColor(.gray)
                        .font(.system(size: 22))
                        .frame(width: 30)
                    SecureField("", text: $password)
                        .placeholder(when: password.isEmpty) {
                            Text("Contraseña").foregroundColor(.gray.opacity(0.7))
                        }
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
            }
            .padding(.horizontal)
        }
        .padding()
    }
    
    var totalQuestions: Int {
        switch userType {
        case .client:
            return 2
        case .lawyer, .student:
            return 2
        case .none:
            return 1
        }
    }
    
    var canProceed: Bool {
        switch currentQuestion {
        case 1:
            return userType != nil
        case 2:
            switch userType {
            case .client:
                return selectedProblem != nil
            case .lawyer:
                return !identification.isEmpty && !password.isEmpty
            case .student:
                return !matricula.isEmpty && !password.isEmpty
            case .none:
                return false
            }
        default:
            return true
        }
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
        case "estudiante":
            self = .student
        default:
            return nil
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {
        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 1 : 0)
            self
        }
    }
}

#Preview{
    QuestionView(showQuestions: .constant(true))
}
