//
//  MapRouteViewModel.swift
//  Runner.io
//
//  Created by Alejandro  on 30/03/25.
//

import Foundation

class MapRouteViewModel: ObservableObject {
    @Published var fetchedRoutes: [Route] = []
    
    init() {
        fetchRoutes()
    }
    
    func fetchRoutes() {
        // Aquí se pasan nil para traer todas las rutas; si se quiere filtrar por usuario, se pasa el userId
        FirestoreManager.fetchRoutes(forUser: nil) { routes in
            DispatchQueue.main.async {
                self.fetchedRoutes = routes
            }
        }
    }
}
