//
//  RunDashboardView.swift
//  Runner.io
//
//  Created by Alejandro  on 29/03/25.
//

import SwiftUI

struct RunDashboardView: View {
    @StateObject var locationManager = LocationManager()
    @State private var isTracking = false
    @State private var startTime: Date? = nil
    @State private var distance: Double = 0.0
    @State private var pace: Double = 0.0
    @State private var isPolygonCompleted = false
    @State private var timer: Timer? = nil
    @State private var currentTime: Date = Date()
    
    @State private var showSaveRunView = false // Trigger for navigation

    var body: some View {
        NavigationView {
            ZStack {
                // Map with route and polygon
                MapRouteView(locationManager: locationManager, isPolygonCompleted: $isPolygonCompleted)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    // Activity Dashboard
                    VStack(spacing: 16) {
                        HStack {
                            VStack {
                                Text("Time")
                                Text(elapsedTime())
                                    .font(.headline)
                            }
                            Spacer()
                            VStack {
                                Text("Distance")
                                Text(String(format: "%.2f km", distance / 1000))
                                    .font(.headline)
                            }
                            Spacer()
                            VStack {
                                Text("Pace")
                                Text(String(format: "%.2f min/km", pace))
                                    .font(.headline)
                            }
                        }
                        .padding()
                    }
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding()

                    Spacer()

                    // Run Button
                    Button(action: toggleTracking) {
                        Text(isTracking ? "Stop Run" : "Start Run")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(isTracking ? Color.red : Color.green)
                            .cornerRadius(10)
                    }
                    .accessibilityLabel(isTracking ? "Stop tracking your run" : "Start tracking your run")
                    .padding()

                    // NavigationLink to SaveRunView
                    NavigationLink(
                        destination: SaveRunView(
                            startTime: startTime ?? Date(),
                            endTime: currentTime,
                            totalDistance: distance,
                            locations: locationManager.locations
                        ),
                        isActive: $showSaveRunView
                    ) {
                        EmptyView()
                    }
                }
                .padding()
            }
            .onChange(of: locationManager.locations) { _ in
                if isTracking {
                    updateMetrics()
                }
            }
        }
    }

    // Toggle tracking state
    private func toggleTracking() {
        if isTracking {
            // Stop tracking
            isTracking = false
            locationManager.stopTracking() // Correct method call
            timer?.invalidate()
            timer = nil

            // Show SaveRunView
            showSaveRunView = true
        } else {
            // Start tracking
            isTracking = true
            startTime = Date()
            distance = 0.0
            pace = 0.0
            locationManager.startTracking() // Correct method call
            
            // Start the timer
            timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                currentTime = Date()
            }
        }
    }

    // Calculate elapsed time
    private func elapsedTime() -> String {
        guard let startTime = startTime, isTracking else { return "00:00" }
        let timeInterval = currentTime.timeIntervalSince(startTime)
        let minutes = Int(timeInterval) / 60
        let seconds = Int(timeInterval) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateMetrics() {
        guard locationManager.locations.count > 1 else { return }
        if let first = locationManager.locations.suffix(2).first,
           let last = locationManager.locations.suffix(2).last {
            let lastDistance = first.distance(from: last)
            distance += lastDistance

            if let startTime = startTime {
                let elapsedTime = Date().timeIntervalSince(startTime) / 60 // Time in minutes
                pace = elapsedTime > 0 ? (distance / 1000) / elapsedTime : 0.0 // Pace in min/km
            }

            // Check if the polygon is completed
            isPolygonCompleted = locationManager.isPolygonClosed()
        }
    }
}
