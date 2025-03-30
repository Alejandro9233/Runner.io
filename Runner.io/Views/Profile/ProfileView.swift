//
//  ProfileView.swift
//  Runner.io
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    

    var body: some View {
        NavigationView {
            ZStack {
                Color(.systemGray6) // Full background color
                    .ignoresSafeArea() // Fill entire screen

                ScrollView {
                    VStack(spacing: 20) {
                        if viewModel.isLoading {
                            ProgressView("Loading...")
                                .padding()
                        } else {
                            VStack {
                                ProfileHeaderView(userName: viewModel.userName, userEmail: viewModel.userEmail)
                                UserInfoView(userEmail: viewModel.userEmail)
                            }
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background((Color(.white)))}
                        
                            SavedRunsView(routes: viewModel.routes)
                            Spacer()
                            SignOutButtonView()
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .onAppear {
                    let userId = AuthService.shared.currentUserId
                    viewModel.fetchUserData(userId: userId)
                }
            }
        }
    }

    
