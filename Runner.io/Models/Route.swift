import Foundation
import CoreLocation

struct Route: Identifiable, Codable {
    let id: UUID // Unique identifier for the route
    let name: String
    let startTime: Date
    let endTime: Date
    let totalDistance: Double
    let locations: [CLLocation]

    // Convert CLLocation to a savable format
    var locationsAsDictionary: [[String: Double]] {
        locations.map { location in
            ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
        }
    }

    // Custom Codable implementation
    enum CodingKeys: String, CodingKey {
        case id, name, startTime, endTime, totalDistance, locations
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(totalDistance, forKey: .totalDistance)
        try container.encode(locationsAsDictionary, forKey: .locations)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        totalDistance = try container.decode(Double.self, forKey: .totalDistance)

        let locationData = try container.decode([[String: Double]].self, forKey: .locations)
        locations = locationData.map { dict in
            CLLocation(latitude: dict["latitude"] ?? 0.0, longitude: dict["longitude"] ?? 0.0)
        }
    }

    // Custom initializer
    init(id: UUID = UUID(), name: String, startTime: Date, endTime: Date, totalDistance: Double, locations: [CLLocation]) {
        self.id = id
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.totalDistance = totalDistance
        self.locations = locations
    }
}
