//
//  RunRowView.swift
//  Runner.io
//

import SwiftUI

struct RunRowView: View {
    let route: Route

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack() {
                Text(route.name)
                    .font(.headline)

                Text("\(formattedDate(route.startTime))")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            HStack(spacing: 50) {
                VStack(alignment: .leading, spacing: -2) {
                    Text("\(String(format: "%.2f", route.totalDistance))")
                    Text("km")
                        .font(.caption)
                }
                VStack(alignment: .leading, spacing: -2) {
                    Text("\(String(format: "%.2f", route.totalDistance))")
                    Text("Avg. Pace")
                        .font(.caption)
                }
                VStack(alignment: .leading, spacing: -2) {
                    Text("\(formattedDuration(start: route.startTime, end: route.endTime))")
                    Text("Time")
                        .font(.caption) 
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(RoundedRectangle(cornerRadius: 10).fill(Color(.white)))
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}

func formattedDuration(start: Date, end: Date) -> String {
    let interval = Int(end.timeIntervalSince(start))
    let hours = interval / 3600
    let minutes = (interval % 3600) / 60

    if hours > 0 {
        return "\(hours)h \(minutes)m"
    } else {
        return "\(minutes)m"
    }
}


#Preview {
    RunRowView(route: Route(
        id: UUID(),
        userId: "testUser123",
        name: "Morning Run",
        startTime: Date(),
        endTime: Date().addingTimeInterval(3600),
        totalDistance: 5.2,
        locations: [] // You can add dummy CLLocation if needed
    ))
}

