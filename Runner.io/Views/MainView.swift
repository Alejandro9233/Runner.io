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
        UITabBar.appearance().backgroundColor = UIColor.white
        UITabBar.appearance().isTranslucent = true
    }
    
    var body: some View {
        if viewModel.isSignedIn, !viewModel.currentUserId.isEmpty{
            accountView
        } else {
            LoginView()
        }
        
    }
    
    @ViewBuilder
    var accountView: some View {
        TabView {
            MapTrackingView().tabItem { Label("Map", systemImage: "globe.americas") }
            RunDashboardView()
                .tabItem {
                    Label("Run", systemImage: "figure.run")
                }
            ProfileView()
                .tabItem {
                    Label("You", systemImage: "person")
                }
        }
    }
}
