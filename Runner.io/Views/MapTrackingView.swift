//
//  MapTrackingView.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import SwiftUI
import MapKit

struct MapTrackingView: View {
    @StateObject var locationManager = LocationManager()
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isPolygonCompleted = false // Tracks if the polygon is completed
    @State private var fetchedRoutes: [Route] = [] 
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            MapRouteView(locationManager: locationManager,
                         isPolygonCompleted: $isPolygonCompleted,
                         fetchedRoutes: fetchedRoutes) // Se pasa el array de rutas
                .edgesIgnoringSafeArea(.all)
            
            // VStack for buttons
            VStack(alignment: .center) {
                // Button to view ranking table
                VStack{
                    Button(action: {
                        // Action to view ranking table
                        print("View Ranking Table")
                    }) {
                        Image(systemName: "medal.star.fill")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "#F27D23")) // Background color for the button
                    .cornerRadius(8)
                    Text("Ranking")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#F27D23"))
                }
                .padding(.top) // Add some space from the top
                
                VStack{
                    Button(action: {
                        print("View Ranking Table")
                    }) {
                        Image(systemName: "house.lodge.circle")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "#3140C2"))
                    .cornerRadius(8)
                    Text("Team")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#3140C2"))
                }
                .padding(.top, 8)
            }
            .padding(15)
            .background(Color.white.opacity(0.5))
            .cornerRadius(8)
            .shadow(radius: 5)
        }
        .onAppear {
            // Lógica para cargar rutas, por ejemplo:
            FirestoreManager.fetchRoutes { routes in
                self.fetchedRoutes = routes
            }
        }
    }
}
