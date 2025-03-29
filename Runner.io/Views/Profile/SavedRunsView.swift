//
//  SavedRunsView.swift
//  Runner.io
//

import SwiftUI

struct SavedRunsView: View {
    let routes: [Route]

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Your Runs")
                .font(.headline)

            if routes.isEmpty {
                Text("No runs saved yet.")
                    .foregroundColor(.gray)
                    .italic()
            } else {
                ForEach(routes, id: \.id) { route in
                    RunRowView(route: route)
                }
            }
        }
        .padding()
    }
}
