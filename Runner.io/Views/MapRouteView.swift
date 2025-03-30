//
//  MapRouteView.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import SwiftUI
import MapKit

struct MapRouteView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var isPolygonCompleted: Bool // Tracks if the polygon is completed
    var fetchedRoutes: [Route]  // New property for all routes fetched from the db
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = false // Disable default user location dot
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear overlays and annotations to avoid duplicates
        uiView.removeOverlays(uiView.overlays)
        uiView.removeAnnotations(uiView.annotations)
        
        if locationManager.isRunning {
            let routeCoordinates = locationManager.locations.map { $0.coordinate }
            
            if isPolygonCompleted && routeCoordinates.count > 2 {
                // Crear un polígono para la ruta actual
                let polygon = MKPolygon(coordinates: routeCoordinates, count: routeCoordinates.count)
                uiView.addOverlay(polygon)
            } else if routeCoordinates.count > 1 {
                // Dibujar la línea (polilínea) de la ruta actual
                let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
                uiView.addOverlay(polyline)
            }
        }
        
        // Add overlays for each fetched route from the database
        for route in fetchedRoutes {
            let coords = route.locations.map { $0.coordinate }
            if coords.count > 2 {
                let polygon = MKPolygon(coordinates: coords, count: coords.count)
                uiView.addOverlay(polygon)
            }
        }
        
        // Add an animated dot for the user's current location
        if let userLocation = locationManager.userLocation {
            let userAnnotation = MKPointAnnotation()
            userAnnotation.coordinate = userLocation.coordinate
            uiView.addAnnotation(userAnnotation)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapRouteView
        
        init(_ parent: MapRouteView) {
            self.parent = parent
        }
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .blue
                renderer.lineWidth = 3
                return renderer
            } else if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.5) // Fill color with transparency
                renderer.strokeColor = .red // Border color
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer()
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            // Custom annotation view for the animated user location dot
            let identifier = "UserLocationDot"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
                annotationView?.layer.cornerRadius = 10
                annotationView?.backgroundColor = UIColor.blue
                annotationView?.layer.borderWidth = 2
                annotationView?.layer.borderColor = UIColor.white.cgColor
                
                // Add animation to the dot
                let animation = CABasicAnimation(keyPath: "opacity")
                animation.fromValue = 1.0
                animation.toValue = 0.3
                animation.duration = 1.0
                animation.autoreverses = true
                animation.repeatCount = .infinity
                annotationView?.layer.add(animation, forKey: "pulse")
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
    }
}
