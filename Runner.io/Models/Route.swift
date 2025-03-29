//
//  Route.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import Foundation
import CoreLocation

struct Route: Identifiable, Codable {
    let id: UUID // Unique identifier for the route
    let name: String // Name of the route (e.g., "Morning Run")
    let startTime: Date // When the route started
    let endTime: Date // When the route ended
    let totalDistance: Double // Total distance covered in meters
    let locations: [CLLocation] // List of locations (coordinates) in the route

    // Computed property to format the total distance in kilometers
    var formattedDistance: String {
        let distanceInKm = totalDistance / 1000
        return String(format: "%.2f km", distanceInKm)
    }

    // Computed property to calculate the duration of the route
    var duration: TimeInterval {
        return endTime.timeIntervalSince(startTime)
    }

    var formattedDuration: String {
        let hours = Int(duration) / 3600
        let minutes = (Int(duration) % 3600) / 60
        return "\(hours)h \(minutes)m"
    }

    // Custom Codable implementation
    enum CodingKeys: String, CodingKey {
        case id, name, startTime, endTime, totalDistance, locations
    }

    // Custom encoding logic
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        // Encode simple properties
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(totalDistance, forKey: .totalDistance)

        // Encode locations as an array of dictionaries
        let locationData = locations.map { location in
            ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
        }
        try container.encode(locationData, forKey: .locations)
    }

    // Custom decoding logic
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // Decode simple properties
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        totalDistance = try container.decode(Double.self, forKey: .totalDistance)

        // Decode locations from an array of dictionaries
        let locationData = try container.decode([[String: Double]].self, forKey: .locations)
        locations = locationData.map { dict in
            CLLocation(latitude: dict["latitude"] ?? 0.0, longitude: dict["longitude"] ?? 0.0)
        }
    }
}
