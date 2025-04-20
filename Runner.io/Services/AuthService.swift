import Foundation
import FirebaseAuth
import GoogleSignIn
import FirebaseCore
import FirebaseFirestore
import UIKit
import Combine

class AuthService: ObservableObject {
    // MARK: - Published Properties
    @Published var authState: AuthState = .unknown
    
    var currentUserId: String {
        return Auth.auth().currentUser?.uid ?? ""
    }
    
    // MARK: - Private Properties
    private let db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()
    private var authStateListener: AuthStateDidChangeListenerHandle?
    

    
    // MARK: - Singleton
    static let shared = AuthService()
    
    // MARK: - Lifecycle
    private init() {
        setupAuthStateListener()
    }
    
    deinit {
        removeAuthStateListener()
    }
    
    // MARK: - Auth State Management
    private func setupAuthStateListener() {
        authStateListener = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            
            if let user = user {
                self.authState = .signedIn(userId: user.uid)
            } else {
                self.authState = .signedOut
            }
        }
    }
    
    private func removeAuthStateListener() {
        if let handle = authStateListener {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    // MARK: - Google Sign In
    func signInWithGoogle(presentingViewController: UIViewController) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            // Ensure Firebase is configured
            guard FirebaseApp.app() != nil else {
                promise(.failure(.configuration))
                return
            }
            
            // Call Google Sign-In
            GIDSignIn.sharedInstance.signIn(withPresenting: presentingViewController) { signInResult, error in
                if let error = error {
                    promise(.failure(.provider(error)))
                    return
                }
                
                guard let result = signInResult,
                      let idToken = result.user.idToken?.tokenString else {
                    promise(.failure(.missingToken))
                    return
                }
                
                let accessToken = result.user.accessToken.tokenString
                
                // Create Firebase credential
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
                
                // Sign in with Firebase
                Auth.auth().signIn(with: credential) { authResult, error in
                    if let error = error {
                        promise(.failure(.firebase(error)))
                        return
                    }
                    
                    // Add or update the user in Firestore
                    if let authResult = authResult {
                        self.addOrUpdateUserInFirestore(authResult: authResult)
                            .sink(receiveCompletion: { completion in
                                if case .failure(let error) = completion {
                                    promise(.failure(error))
                                }
                            }, receiveValue: { _ in
                                promise(.success(()))
                            })
                            .store(in: &self.cancellables)
                    } else {
                        promise(.failure(.unknown))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Firestore User Management
    private func addOrUpdateUserInFirestore(authResult: AuthDataResult) -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { [weak self] promise in
            guard let self = self else {
                promise(.failure(.unknown))
                return
            }
            
            let user = authResult.user
            let userRef = self.db.collection("users").document(user.uid)
            
            // Fetch current user data from Firestore
            userRef.getDocument { snapshot, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
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
                            promise(.failure(.firestore(error)))
                        } else {
                            promise(.success(()))
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
                            promise(.failure(.firestore(error)))
                        } else {
                            promise(.success(()))
                        }
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    // MARK: - Sign Out
    func signOut() -> AnyPublisher<Void, AuthError> {
        return Future<Void, AuthError> { promise in
            do {
                // Sign out from Firebase
                try Auth.auth().signOut()
                
                // Sign out from Google
                GIDSignIn.sharedInstance.signOut()
                
                promise(.success(()))
            } catch let signOutError {
                promise(.failure(.signOut(signOutError)))
            }
        }.eraseToAnyPublisher()
    }
}

// MARK: - Auth State Enum
enum AuthState: Equatable {
    case unknown
    case signedOut
    case signedIn(userId: String)
    
    var isSignedIn: Bool {
        if case .signedIn = self {
            return true
        }
        return false
    }
    
    var userId: String {
        if case .signedIn(let userId) = self {
            return userId
        }
        return ""
    }
}

// MARK: - Auth Error Enum
enum AuthError: Error, LocalizedError {
    case unknown
    case configuration
    case missingToken
    case provider(Error)
    case firebase(Error)
    case firestore(Error)
    case signOut(Error)
    
    var errorDescription: String? {
        switch self {
        case .unknown:
            return "An unknown error occurred"
        case .configuration:
            return "Firebase is not properly configured"
        case .missingToken:
            return "Authentication token is missing"
        case .provider(let error):
            return "Provider error: \(error.localizedDescription)"
        case .firebase(let error):
            return "Firebase authentication error: \(error.localizedDescription)"
        case .firestore(let error):
            return "Firestore error: \(error.localizedDescription)"
        case .signOut(let error):
            return "Sign out error: \(error.localizedDescription)"
        }
    }
}
