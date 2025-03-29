//
//  RunRowView.swift
//  Runner.io
//

import SwiftUI

struct RunRowView: View {
    let route: Route

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(route.name)
                    .font(.headline)

                Text("\(String(format: "%.2f", route.totalDistance)) km - \(formattedDate(route.startTime))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding()
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.systemGray6)))
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
