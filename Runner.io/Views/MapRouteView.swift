import SwiftUI
import MapKit

struct MapRouteView: UIViewRepresentable {
    @ObservedObject var locationManager: LocationManager
    @Binding var isPolygonCompleted: Bool // Tracks if the polygon is completed
    var fetchedRoutes: [Route]  // Array of routes fetched from Firestore
    
    let currentUserId = AuthService.shared.currentUserId // Current user's ID
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Clear overlays to avoid duplicates
        uiView.removeOverlays(uiView.overlays)
        
        // Render current user's running route
        if locationManager.isRunning {
            let routeCoordinates = locationManager.locations.map { $0.coordinate }
            if isPolygonCompleted && routeCoordinates.count > 2 {
                let polygon = MKPolygon(coordinates: routeCoordinates, count: routeCoordinates.count)
                polygon.title = "currentRoute"
                uiView.addOverlay(polygon)
            } else if routeCoordinates.count > 1 {
                let polyline = MKPolyline(coordinates: routeCoordinates, count: routeCoordinates.count)
                uiView.addOverlay(polyline)
            }
        }
        
        // Render all fetched routes
        for route in fetchedRoutes {
            let coords = route.locations.map { $0.coordinate }
            if coords.count > 2 {
                let polygon = MKPolygon(coordinates: coords, count: coords.count)
                
                // Differentiate by user ID
                if route.userId == currentUserId {
                    polygon.title = "myRoute"
                } else {
                    polygon.title = "otherRoute"
                }
                uiView.addOverlay(polygon)
            }
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
            if let polygonOverlay = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygonOverlay)
                
                // Apply styles based on the polygon title
                if let title = polygonOverlay.title {
                    if title == "currentRoute" {
                        renderer.strokeColor = UIColor.red
                        renderer.fillColor = UIColor.red.withAlphaComponent(0.3)
                        renderer.lineWidth = 3
                    } else if title == "myRoute" {
                        renderer.strokeColor = UIColor.blue
                        renderer.fillColor = UIColor.blue.withAlphaComponent(0.2)
                        renderer.lineWidth = 2
                    } else if title == "otherRoute" {
                        renderer.strokeColor = UIColor.green
                        renderer.fillColor = UIColor.green.withAlphaComponent(0.2)
                        renderer.lineWidth = 2
                    }
                }
                return renderer
            } else if let polylineOverlay = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polylineOverlay)
                renderer.strokeColor = UIColor.orange
                renderer.lineWidth = 3
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
