//
//  LoginView.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//
import SwiftUI
import GoogleSignIn
import Combine

struct LoginView: View {
    @StateObject private var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            // Background gradient
            backgroundGradient
            
            VStack(spacing: 0) {
                Spacer()
                
                // App logo/title
                appLogo
                
                // Card view containing quote, globe and buttons
                loginCard
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Sign In Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.93, green: 0.52, blue: 0.25),
                Color(red: 0.86, green: 0.48, blue: 0.40),
                Color(red: 0.76, green: 0.47, blue: 0.67),
                Color(red: 0.46, green: 0.35, blue: 0.75),
                Color(red: 0.20784313725490197, green: 0.25098039215686274, blue: 0.7450980392156863)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
    
    private var appLogo: some View {
        Image("runnerioTexto")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 200, height: 160)
            .padding([.top, .leading, .trailing], 30)
    }
    
    private var loginCard: some View {
        ZStack {
            // Card background
            RoundedRectangle(cornerRadius: 30)
                .fill(Color.white.opacity(0.2))
                .frame(width: 350, height: 490)
                .padding(.horizontal, 0)
            
            VStack(spacing: 10) {
                // Quote and globe section
                quoteAndGlobeSection
                
                // Begin now text
                Text("Begin now")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundColor(Color.white.opacity(0.5))
                    .padding(.bottom, 13)
                
                // Sign in with Google button
                googleSignInButton
                
                Spacer()
                    .frame(height: 40)
            }
            .padding(.bottom, 20)
        }
    }
    
    private var quoteAndGlobeSection: some View {
        HStack(alignment: .center) {
            // Quote
            Text("\"The earth is yours to conquer, not through war, but through steps\"")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.white)
                .multilineTextAlignment(.leading)
                .lineLimit(nil)
                .padding(.leading, 50)
                .padding(.top, 40)
            
            Spacer()
            
            // Globe image
            Image("globe_image")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150, height: 150)
                .padding(.trailing, 50)
                .shadow(color: .black, radius: 3, x: -5, y: 5)
        }
        .padding(.top, 40)
    }
    
    private var googleSignInButton: some View {
        Button(action: viewModel.signInWithGoogle) {
            HStack {
                Image("google_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .padding(.leading, 8)
                
                Text("Sign in with Google")
                    .font(.system(size: 18))
                    .fontWeight(.medium)
                    .padding(.leading, 8)
            }
            .frame(maxWidth: 300)
            .frame(height: 56)
            .background(Color.white)
            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            .cornerRadius(28)
        }
        .padding(.horizontal, 30)
        .padding(.bottom, 16)
    }
}

// MARK: - LoginViewModel
class LoginViewModel: ObservableObject {
    @Published var showError = false
    @Published var errorMessage = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    func signInWithGoogle() {
        guard let rootViewController = UIApplication.shared
            .connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .flatMap({ $0.windows })
            .first(where: { $0.isKeyWindow })?.rootViewController else {
                self.showError(message: "Unable to get root view controller")
                return
            }
        
        AuthService.shared.signInWithGoogle(presentingViewController: rootViewController)
            .receive(on: RunLoop.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    if case .failure(let error) = completion {
                        self?.showError(message: error.localizedDescription)
                    }
                },
                receiveValue: { _ in
                    print("Successfully signed in with Google")
                }
            )
            .store(in: &cancellables)
    }
    
    private func showError(message: String) {
        self.errorMessage = message
        self.showError = true
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
