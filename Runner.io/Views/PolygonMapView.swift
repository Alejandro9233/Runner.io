//
//  PolygonMapView.swift
//  Runner.io
//
//  Created by Alejandro  on 28/03/25.
//

import SwiftUI
import MapKit

struct PolygonMapView: UIViewRepresentable {
    @Binding var coordinates: [CLLocationCoordinate2D] // User's path
    @Binding var polygonCompleted: Bool // Indicates if the polygon is completed

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }

    func updateUIView(_ mapView: MKMapView, context: Context) {
        // Clear existing overlays
        mapView.removeOverlays(mapView.overlays)

        // Add polygon overlay if the polygon is completed
        if polygonCompleted && coordinates.count > 2 {
            let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
            mapView.addOverlay(polygon)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: PolygonMapView

        init(_ parent: PolygonMapView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polygon = overlay as? MKPolygon {
                let renderer = MKPolygonRenderer(polygon: polygon)
                renderer.fillColor = UIColor.red.withAlphaComponent(0.5) // Fill color with transparency
                renderer.strokeColor = UIColor.red // Border color
                renderer.lineWidth = 2
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}
