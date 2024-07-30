//
//  AuthService.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.07.2024.
//

import Foundation
import FirebaseAuth
import Combine

protocol AuthService {
    func signIn(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error>
}
