//
//  LocationService.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import Foundation
import CoreLocation

class LocationService {
    // Save route to Firebase or local storage
    func saveRoute(route: Route, completion: @escaping (Result<Void, Error>) -> Void) {
        // Convert route to JSON and upload to Firebase
        // Example Firebase logic here
        completion(.success(()))
    }

    // Fetch routes from Firebase or local storage
    func fetchRoutes(completion: @escaping (Result<[Route], Error>) -> Void) {
        // Example Firebase fetch logic here
        completion(.success([])) // Return empty array for now
    }

    // Calculate total distance for a list of locations
    func calculateTotalDistance(from locations: [CLLocation]) -> Double {
        guard locations.count > 1 else { return 0.0 }
        var totalDistance: Double = 0.0
        for i in 1..<locations.count {
            totalDistance += locations[i - 1].distance(from: locations[i])
        }
        return totalDistance
    }
}
