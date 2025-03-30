//
//  PolygonHelper.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import Foundation
import CoreLocation

struct PolygonHelper {
    // Calculate the area of a polygon using the Shoelace formula
    static func calculateArea(coordinates: [CLLocationCoordinate2D]) -> Double {
        guard coordinates.count > 2 else { return 0.0 }

        var area: Double = 0.0
        for i in 0..<coordinates.count {
            let point1 = coordinates[i]
            let point2 = coordinates[(i + 1) % coordinates.count] // Wrap around to the first point
            area += point1.latitude * point2.longitude - point2.latitude * point1.longitude
        }

        return abs(area) / 2.0 // Return the absolute value of the area
    }
}
