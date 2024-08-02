//
//  FirebaseAuthService.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.07.2024.
//

import FirebaseAuth
import FirebaseFirestore
import Combine

class FirebaseAuthService: AuthService {
    static let shared = FirebaseAuthService()
    private let db = Firestore.firestore()
    
    init() {}
    
    // Sign up with email, password, and name
    func signUp(email: String, password: String, name: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    self.saveUserName(authResult.user, name: name) { result in
                        switch result {
                        case .success():
                            promise(.success(authResult))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    private func saveUserName(_ firebaseUser: FirebaseAuth.User, name: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let userData: [String: Any] = ["uid": firebaseUser.uid, "email": firebaseUser.email ?? "", "name": name]
        db.collection("users").document(firebaseUser.uid).setData(userData) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    // Sign in with email and password
    func signIn(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        return Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    promise(.failure(error))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Sign out
    func signOut() -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            do {
                try Auth.auth().signOut()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Send password reset email
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error> {
        return Future<Void, Error> { promise in
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    promise(.failure(error))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    // Error translator
    func translateError(_ error: Error) -> String {
        let nsError = error as NSError
        switch nsError.code {
        case AuthErrorCode.networkError.rawValue:
            return "Проблеми з підключенням до мережі. Спробуйте ще раз."
        case AuthErrorCode.userNotFound.rawValue:
            return "Користувача не знайдено. Перевірте введені дані."
        case AuthErrorCode.invalidEmail.rawValue:
            return "Неправильний формат електронної пошти."
        case AuthErrorCode.emailAlreadyInUse.rawValue:
            return "Ця електронна пошта вже використовується."
        case AuthErrorCode.weakPassword.rawValue:
            return "Пароль занадто слабкий. Використовуйте щонайменше 8 символів, включаючи одну велику літеру, одну малу літеру та одну цифру."
        case AuthErrorCode.wrongPassword.rawValue:
            return "Неправильний пароль. Спробуйте ще раз."
        default:
            return "Невідома помилка: \(nsError.localizedDescription)"
        }
    }

}
