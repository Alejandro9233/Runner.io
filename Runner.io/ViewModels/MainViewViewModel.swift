//
//  MainViewViewModel.swift
//  Runner.io
//
//  Created by Alejandro  on 19/01/25.
//

import FirebaseAuth
import Combine

class MainViewViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var currentUserId: String = ""

    private var authStateListenerHandle: AuthStateDidChangeListenerHandle?

    init() {
        // Start listening for authentication state changes
        authStateListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else { return }
            if let user = user {
                self.isSignedIn = true
                self.currentUserId = user.uid
            } else {
                self.isSignedIn = false
                self.currentUserId = ""
            }
        }
    }

    deinit {
        // Remove the listener when the view model is deallocated
        if let handle = authStateListenerHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
