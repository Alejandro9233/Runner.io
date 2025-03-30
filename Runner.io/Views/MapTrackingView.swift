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
    @StateObject var routeVM = MapRouteViewModel() // ViewModel to fetch routes
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    @State private var isPolygonCompleted = false // Tracks if the polygon is completed
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Map with route and polygons
            MapRouteView(locationManager: locationManager,
                         isPolygonCompleted: $isPolygonCompleted,
                         fetchedRoutes: routeVM.fetchedRoutes) // Pass fetched routes
                .edgesIgnoringSafeArea(.all)
            
            // Buttons for ranking and team views
            VStack(alignment: .center) {
                VStack {
                    Button(action: {
                        print("View Ranking Table")
                    }) {
                        Image(systemName: "medal.star.fill")
                            .foregroundColor(Color.white)
                            .font(.title)
                    }
                    .frame(width: 40, height: 40)
                    .background(Color(hex: "#F27D23"))
                    .cornerRadius(8)
                    Text("Ranking")
                        .font(.caption)
                        .foregroundColor(Color(hex: "#F27D23"))
                }
                .padding(.top)
                
                VStack {
                    Button(action: {
                        print("View Team")
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
            routeVM.fetchRoutes() // Fetch routes when the view appears
        }
    }
}
