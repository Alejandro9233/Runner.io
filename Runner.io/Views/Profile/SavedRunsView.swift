//
//  SavedRunsView.swift
//  Runner.io
//

import SwiftUI

struct SavedRunsView: View {
    let routes: [Route]

    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer()
            Text("Recent Activity")
                .font(.headline)
                .padding(.bottom, 5)

            if routes.isEmpty {
                emptyStateView
            } else {
                routesList
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 10) {
            Image(systemName: "figure.run")
                .font(.system(size: 40))
                .foregroundColor(.gray.opacity(0.7))
                .padding()
            
            Text("No runs saved yet")
                .font(.subheadline)
                .foregroundColor(.gray)
            
            Text("Your running history will appear here")
                .font(.caption)
                .foregroundColor(.gray.opacity(0.8))
        }
        .frame(maxWidth: .infinity)
        .padding()
    }
    
    private var routesList: some View {
        VStack(spacing: 15) {
            ForEach(routes) { route in
                RunRowView(route: route)
            }
        }
    }
}
