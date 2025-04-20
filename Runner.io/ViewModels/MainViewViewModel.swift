//
//  MainViewViewModel.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import Foundation
import Combine

class MainViewViewModel: ObservableObject {
    @Published var authState: AuthState = .unknown
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Subscribe to auth state changes from AuthService
        AuthService.shared.$authState
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
                self?.authState = state
            }
            .store(in: &cancellables)
    }
    
    func signOut() {
        AuthService.shared.signOut()
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Error signing out: \(error.localizedDescription)")
                    }
                },
                receiveValue: { _ in
                    print("Successfully signed out")
                }
            )
            .store(in: &cancellables)
    }
}
