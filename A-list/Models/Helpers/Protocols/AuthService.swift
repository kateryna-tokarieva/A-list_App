//
//  AuthService.swift
//  A-list
//
//  Created by Екатерина Токарева on 30.07.2024.
//

import FirebaseAuth
import Combine

protocol AuthService {
    /// Signs in a user with an email and password.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    /// - Returns: A publisher that emits an `AuthDataResult` on successful authentication or an `Error` on failure.
    func signIn(withEmail email: String, password: String) -> AnyPublisher<AuthDataResult, Error>
    
    /// Registers a user with an email, password, and name.
    /// - Parameters:
    ///   - email: The user's email address.
    ///   - password: The user's password.
    ///   - name: The user's full name.
    /// - Returns: A publisher that emits an `AuthDataResult` on successful registration or an `Error` on failure.
    func signUp(email: String, password: String, name: String) -> AnyPublisher<AuthDataResult, Error>
    
    /// Signs out the current user.
    /// - Returns: A publisher that completes when the user is signed out or emits an `Error` on failure.
    func signOut() -> AnyPublisher<Void, Error>
    
    /// Sends a password reset email to the specified email address.
    /// - Parameter email: The email address to which to send the password reset email.
    /// - Returns: A publisher that completes when the email is sent or emits an `Error` on failure.
    func sendPasswordReset(email: String) -> AnyPublisher<Void, Error>
    
    /// Translates an authentication error into a user-friendly message.
    /// - Parameter error: The error to translate.
    /// - Returns: A user-friendly error message string.
    func translateError(_ error: Error) -> String
}

