import Foundation
import CoreLocation

struct Route: Identifiable, Codable {
    let id: UUID // Identificador único de la ruta
    let userId: String // Agregamos la propiedad para identificar al dueño de la ruta
    let name: String
    let startTime: Date
    let endTime: Date
    let totalDistance: Double
    let locations: [CLLocation]

    // Convertir CLLocation a un formato que se pueda guardar
    var locationsAsDictionary: [[String: Double]] {
        locations.map { location in
            ["latitude": location.coordinate.latitude, "longitude": location.coordinate.longitude]
        }
    }

    enum CodingKeys: String, CodingKey {
        case id, userId, name, startTime, endTime, totalDistance, locations
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(userId, forKey: .userId)
        try container.encode(name, forKey: .name)
        try container.encode(startTime, forKey: .startTime)
        try container.encode(endTime, forKey: .endTime)
        try container.encode(totalDistance, forKey: .totalDistance)
        try container.encode(locationsAsDictionary, forKey: .locations)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        userId = try container.decode(String.self, forKey: .userId)
        name = try container.decode(String.self, forKey: .name)
        startTime = try container.decode(Date.self, forKey: .startTime)
        endTime = try container.decode(Date.self, forKey: .endTime)
        totalDistance = try container.decode(Double.self, forKey: .totalDistance)
        let locationData = try container.decode([[String: Double]].self, forKey: .locations)
        locations = locationData.map { dict in
            CLLocation(latitude: dict["latitude"] ?? 0.0, longitude: dict["longitude"] ?? 0.0)
        }
    }

    // Inicializador personalizado
    init(id: UUID = UUID(), userId: String, name: String, startTime: Date, endTime: Date, totalDistance: Double, locations: [CLLocation]) {
        self.id = id
        self.userId = userId
        self.name = name
        self.startTime = startTime
        self.endTime = endTime
        self.totalDistance = totalDistance
        self.locations = locations
    }
}