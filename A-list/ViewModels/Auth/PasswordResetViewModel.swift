//
//  PasswordResetViewModel.swift
//  A-list
//
//  Created by Екатерина Токарева on 21.07.2024.
//

import Foundation
import FirebaseAuth

class PasswordResetViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var errorMessage: String = ""
    @Published var successMessage: String = ""
    
    func sendPasswordReset(email: String) {
        self.email = email.trimmingCharacters(in: .whitespaces)

        Auth.auth().sendPasswordReset(withEmail: self.email) { error in
            if let error {
                self.errorMessage = self.translateError(error)
            } else {
                self.successMessage = "Лист для відновлення паролю успішно відправлено."
                self.errorMessage = ""
            }
        }
    }
    
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    private func translateError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.networkError.rawValue:
            return "Проблеми з підключенням до мережі. Спробуйте ще раз."
        case AuthErrorCode.userNotFound.rawValue:
            return "Користувача не знайдено. Перевірте введені дані."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Неправильний формат електронної пошти."
        default:
            return "Невідома помилка: \(nsError.localizedDescription)"
        }
    }
}

