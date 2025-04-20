//
//  ProfileView.swift
//  Runner.io
//

import SwiftUI

struct ProfileView: View {
    let signOut: () -> Void
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            VStack {
                                ProfileHeaderView(userName: viewModel.userName, userEmail: viewModel.userEmail)
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                UserInfoView(userEmail: viewModel.userEmail)
                            }
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                        }
                        
                        SavedRunsView(routes: viewModel.routes)
                            .padding()
                            .background(Color(hex:"#f8f8f6"))
                        Spacer()
                        signOutButton
                    }
                }
                .scrollIndicators(.hidden) // Optional: hides scroll indicators
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let userId = AuthService.shared.currentUserId
                viewModel.fetchUserData(userId: userId)
            }
        }
    }
    
    private var signOutButton: some View {
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
        .padding(.top, 10)
    }
}
