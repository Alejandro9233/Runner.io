//
//  LocationManager.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: CLLocation?
    @Published var locations: [CLLocation] = [] // Store route points
    private var locationManager = CLLocationManager()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }
        DispatchQueue.main.async {
            self.userLocation = newLocation
            self.locations.append(newLocation) // Append to route
        }
    }

    func startTracking() {
        locationManager.startUpdatingLocation()
    }

    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    func isPolygonClosed() -> Bool {
        guard locations.count > 2 else { return false }
        let start = locations.first!
        let end = locations.last!
        let thresholdDistance: CLLocationDistance = 10.0 // 10 meters tolerance

        return start.distance(from: end) < thresholdDistance
    }

}
