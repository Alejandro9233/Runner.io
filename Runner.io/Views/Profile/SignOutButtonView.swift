//
//  SignOutButtonView.swift
//  Runner.io
//

import SwiftUI

struct SignOutButtonView: View {
    var body: some View {
        Button(action: {
            signOut()
        }) {
            Text("Sign Out")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.red)
                .cornerRadius(10)
        }
    }

    private func signOut() {
        AuthService.shared.signOut { result in
            switch result {
            case .success:
                print("Successfully signed out!")
                // Navigate back to the Login screen
            case .failure(let error):
                print("Error signing out: \(error.localizedDescription)")
            }
        }
    }
}
