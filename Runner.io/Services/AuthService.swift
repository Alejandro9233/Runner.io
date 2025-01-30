//
//  AuthService.swift
//  Runner.io
//
//  Created by Alejandro  on 29/01/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import UIKit

class AuthService: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUserId: String = ""
    
    static let shared = AuthService() // Singleton for global access
    
    private init() {
        self.isSignedIn = Auth.auth().currentUser != nil
        self.currentUserId = Auth.auth().currentUser?.uid ?? ""
    }
    
    func signInWithGoogle(presentingViewController: UIViewController, completion: @escaping (Result<Void, Error>) -> Void) {
        // Ensure Firebase is configured
        guard FirebaseApp.app() != nil else {
            completion(.failure(NSError(domain: "FirebaseNotConfigured", code: 0, userInfo: nil)))
            return
        }
        
        // Call Google Sign-In
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let result = signInResult,
                  let idToken = result.user.idToken?.tokenString else {
                completion(.failure(NSError(domain: "MissingAuthToken", code: 0, userInfo: nil)))
                return
            }
            
            let accessToken = result.user.accessToken.tokenString
            
            // Create Firebase credential
            let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
            
            // Sign in with Firebase
            Auth.auth().signIn(with: credential) { authResult, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                DispatchQueue.main.async {
                    self.isSignedIn = true
                    self.currentUserId = Auth.auth().currentUser?.uid ?? ""
                    completion(.success(()))
                }
            }
        }
    }
    
    
    
    func signOut(completion: @escaping (Result<Void, Error>) -> Void) {
            do {
                // Sign out from Firebase
                try Auth.auth().signOut()

                // Sign out from Google
                GIDSignIn.sharedInstance.signOut()

                completion(.success(()))
            } catch let signOutError {
                completion(.failure(signOutError))
            }
        }
}
