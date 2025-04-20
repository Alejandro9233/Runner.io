//
//  MainView.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
    init() {
        configureTabBarAppearance()
    }
    
    var body: some View {
        Group {
            switch viewModel.authState {
            case .signedIn:
                accountView
            case .signedOut, .unknown:
                LoginView()
            }
        }
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            MapTrackingView()
                .tabItem { Label("Map", systemImage: "globe.americas") }
            
            RunDashboardView()
                .tabItem { Label("Run", systemImage: "figure.run") }
            
            ProfileView(signOut: viewModel.signOut)
                .tabItem { Label("You", systemImage: "person") }
        }
    }
    
    private func configureTabBarAppearance() {
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = true
    }
}
