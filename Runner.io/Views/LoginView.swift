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
        ZStack {
            // Background gradient - kept the same 5-point gradient
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 0.93, green: 0.52, blue: 0.25), // Orange at top
                    Color(red: 0.86, green: 0.48, blue: 0.40), // Orange-pink transition
                    Color(red: 0.76, green: 0.47, blue: 0.67), // Purple in middle
                    Color(red: 0.46, green: 0.35, blue: 0.75), // Purple-blue transition
                    Color(red: 0.20784313725490197, green: 0.25098039215686274, blue: 0.7450980392156863)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // App logo/title as image instead of text
                Image("runnerioTexto") // Using the image name you provided
                   .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 160) // Adjust width as needed
                    .padding([.top, .leading, .trailing], 30)
                
                // Card view containing quote, globe and buttons
                ZStack {
                    // Card background
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 380, height: 400)
                        .padding(.horizontal, 0)
                    
                    VStack(spacing: 10) {
                        // Quote and globe section
                        HStack(alignment: .center) {
                               // Quote
                               Text("\"The earth is yours to conquer, not through war, but through steps\"")
                                   .font(.system(size: 28, weight: .bold))
                                   .foregroundColor(.white)
                                   .multilineTextAlignment(.leading)
                                   .lineLimit(nil) // This ensures the text wraps instead of getting cut off
                                   .padding(.leading, 30)
                                   .padding(.top, 40)
                               
                               Spacer()
                               
                               // Globe image - using your size settings
                               Image("globe_image")
                                   .resizable()
                                   .aspectRatio(contentMode: .fit)
                                   .frame(width: 180, height: 180)
                                   .padding(.trailing, 30)
                                   .shadow(color: .black, radius: 3, x: -5, y: 5) 
                           }
                        .padding(.top, 40)
                        
                        // Begin now text - keeping your font weight and opacity
                        Text("Begin now")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(Color.white.opacity(0.5))
                            .padding(.bottom, 13)
                        
                        // Sign in with Google button
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
                            .frame(maxWidth: 300) // Using your fixed width
                            .frame(height: 56)
                            .background(Color.white)
                            .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
                            .cornerRadius(28)
                        }
                        .padding(.horizontal, 30)
                        .padding(.bottom, 16)
                        
                        Spacer()
                            .frame(height: 40)
                    }
                    .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
