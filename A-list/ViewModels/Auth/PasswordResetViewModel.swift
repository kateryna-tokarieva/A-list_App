//
//  PasswordResetViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 21.07.2024.
//

import Foundation
import Combine
import FirebaseAuth

class PasswordResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    var successPublisher = PassthroughSubject<Void, Never>()
    
    private let authService: AuthService
    private var cancellables = Set<AnyCancellable>()
    
    init(authService: AuthService = FirebaseAuthService.shared) {
        self.authService = authService
    }
    
    func sendPasswordReset() {
        email = email.trimmingCharacters(in: .whitespacesAndNewlines)

        guard isValidEmail(email) else {
            errorMessage = "Неправильний формат електронної пошти."
            return
        }

        authService.sendPasswordReset(email: email)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.errorMessage = self?.authService.translateError(error) ?? "Невідома помилка"
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] in
                self?.errorMessage = ""
                self?.successPublisher.send(())
            })
            .store(in: &cancellables)
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
}
