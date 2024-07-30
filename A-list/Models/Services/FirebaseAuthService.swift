//
//  FirebaseAuthService.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.07.2024.
//

import Foundation
import FirebaseAuth
import Combine

class FirebaseAuthService: AuthService {
    func signIn(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error> {
        Future<AuthDataResult, Error> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                if let error = error {
                    promise(.failure(error))
                } else if let result = result {
                    promise(.success(result))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}
