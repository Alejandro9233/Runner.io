//
//  ProfileView.swift
//  Runner.io
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else {
                        ProfileHeaderView(userName: viewModel.userName, userEmail: viewModel.userEmail)
                        UserInfoView(userEmail: viewModel.userEmail)
                        SavedRunsView(routes: viewModel.routes)
                        SignOutButtonView()
                    }
                }
                .padding()
                .navigationTitle("Profile")
                .navigationBarTitleDisplayMode(.inline)
            }
            .onAppear {
                // Replace this with the actual user ID from your auth service
                let userId = AuthService.shared.currentUserId
                viewModel.fetchUserData(userId: userId)
            }
        }
    }
}
