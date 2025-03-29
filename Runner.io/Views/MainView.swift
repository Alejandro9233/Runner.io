//
//  MainView.swift
//  Runner.io
//
//  Created by Alejandro  on 19/01/25.
//

import SwiftUI

struct MainView: View {
    @StateObject var viewModel = MainViewViewModel()
    
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
            MapView(userId: viewModel.currentUserId)
                .tabItem{
                    Label("Home", systemImage: "house")
                }
            MapTrackingView().tabItem { Label("Map", systemImage: "map.circle") }
            ProfileView()
                .tabItem {
                    Label("You", systemImage: "person.circle")
                }
        }
    }
}

#Preview {
    MainView()
}
