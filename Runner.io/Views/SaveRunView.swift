//
//  SaveRunView.swift
//  Runner.io
//
//  Created by Alejandro  on 29/03/25.
//

import SwiftUI
import CoreLocation

struct SaveRunView: View {
    @State private var routeName: String = ""
    @State private var isSaving: Bool = false
    @State private var saveResult: String = ""

    let firestoreManager = FirestoreManager()
    let authService = AuthService.shared

    // Run data passed from RunDashboardView
    let startTime: Date
    let endTime: Date
    let totalDistance: Double
    let locations: [CLLocation]

    var body: some View {
        VStack(spacing: 20) {
            TextField("Route Name", text: $routeName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            if isSaving {
                ProgressView()
            } else {
                Button("Save Run") {
                    saveRun()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
            }

            Text(saveResult)
                .foregroundColor(.green)
        }
        .padding()
    }

    private func saveRun() {
        guard !routeName.isEmpty else {
            saveResult = "Please enter a route name."
            return
        }

        isSaving = true
        saveResult = ""

        // Create a Route object from the passed-in data
        let route = Route(
            id: UUID(),
            name: routeName,
            startTime: startTime,
            endTime: endTime,
            totalDistance: totalDistance,
            locations: locations
        )

        // Save the route to Firestore
        FirestoreManager.saveRoute(userId: authService.currentUserId, route: route) { result in
            DispatchQueue.main.async {
                isSaving = false
                switch result {
                case .success:
                    saveResult = "Run saved successfully!"
                    routeName = ""
                case .failure(let error):
                    saveResult = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
}
