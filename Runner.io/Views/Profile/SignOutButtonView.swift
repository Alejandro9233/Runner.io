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
                .frame(width: 200)
                .background(Color(red: 0.93, green: 0.52, blue: 0.25))
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
