//
//  AuthService.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore
import UIKit

class AuthService: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUserId: String = ""
    
    static let shared = AuthService() // Singleton for global access
    
    private let db = Firestore.firestore() // Firestore instance
    
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
                    
                    // Add or update the user in Firestore
                    if let authResult = authResult {
                        self.addOrUpdateUserInFirestore(authResult: authResult) { dbResult in
                            switch dbResult {
                            case .success:
                                completion(.success(()))
                            case .failure(let dbError):
                                completion(.failure(dbError))
                            }
                        }
                    } else {
                        completion(.failure(NSError(domain: "AuthResultMissing", code: 0, userInfo: nil)))
                    }
                }
            }
        }
    }
    
    // MARK: - Add or Update User in Firestore
    private func addOrUpdateUserInFirestore(authResult: AuthDataResult, completion: @escaping (Result<Void, Error>) -> Void) {
        let user = authResult.user // No need for guard let or if let since 'user' is non-optional
        
        let userRef = db.collection("users").document(user.uid)
        
        // Fetch current user data from Firestore
        userRef.getDocument { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // If the user already exists, update their data
            if let snapshot = snapshot, snapshot.exists {
                userRef.updateData([
                    "name": user.displayName ?? "Anonymous",
                    "email": user.email ?? "",
                    "profileImageUrl": user.photoURL?.absoluteString ?? "",
                    "updatedAt": FieldValue.serverTimestamp()
                ]) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            } else {
                // If the user doesn't exist, create a new document
                let newUser = [
                    "id": user.uid,
                    "name": user.displayName ?? "Anonymous",
                    "email": user.email ?? "",
                    "profileImageUrl": user.photoURL?.absoluteString ?? "",
                    "totalDistanceRun": 0.0,
                    "achievements": [],
                    "friends": [],
                    "createdAt": FieldValue.serverTimestamp(),
                    "updatedAt": FieldValue.serverTimestamp()
                ] as [String : Any]
                
                userRef.setData(newUser) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
            }
        }
    }

    
    // MARK: - Sign Out
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
