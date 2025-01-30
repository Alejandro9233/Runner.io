//
//  ProfileView.swift
//  Runner.io
//
//  Created by Alejandro  on 19/01/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        VStack {
            // Your profile content here
            Text("Welcome to your profile!")
                .font(.title)
                .padding()

            Spacer()

            // Sign-Out Button
            Button(action: {
                signOut()
            }) {
                Text("Sign Out")
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .cornerRadius(8)
            }
            .padding()
        }
    }

    func signOut() {
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
