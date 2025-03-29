//
//  MapTrackingView.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import SwiftUI
import MapKit

struct MapTrackingView: View {
    @StateObject var locationManager = LocationManager()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isPolygonCompleted = false // Tracks if the polygon is completed

    var body: some View {
        ZStack {
            // Map with route and polygon
            MapRouteView(locationManager: locationManager, isPolygonCompleted: $isPolygonCompleted)
                .edgesIgnoringSafeArea(.all)

            // User's current coordinates displayed at the top-right corner
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Latitude: \(locationManager.userLocation?.coordinate.latitude ?? 0.0, specifier: "%.6f")")
                        Text("Longitude: \(locationManager.userLocation?.coordinate.longitude ?? 0.0, specifier: "%.6f")")
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding()
            }
        }
    }
}
