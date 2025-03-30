//
//  LoginView.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import SwiftUI
import GoogleSignIn

struct LoginView: View {
    var body: some View {
        VStack {
            Text("Welcome to Runner.io")
                .font(.largeTitle)
                .padding()

            Button(action: {
                if let rootViewController = UIApplication.shared
                    .connectedScenes
                    .compactMap({ $0 as? UIWindowScene })
                    .flatMap({ $0.windows })
                    .first(where: { $0.isKeyWindow })?.rootViewController {
                        
                    AuthService.shared.signInWithGoogle(presentingViewController: rootViewController) { result in
                        switch result {
                        case .success:
                            print("Signed in successfully")
                        case .failure(let error):
                            print("Error signing in: \(error.localizedDescription)")
                        }
                    }
                } else {
                    print("Error: Unable to get rootViewController")
                }
            }) {
                HStack {
                    Image(systemName: "person.crop.circle")
                    Text("Sign in with Google")
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
        }
    }
}
