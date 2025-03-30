//
//  FirestoreManager.swift
//  Runner.io
//
//  Created by Alejandro on 28/03/25.
//

import FirebaseFirestore

class FirestoreManager {
    private static let db = Firestore.firestore()
    
    // Save a route to Firestore
    static func saveRoute(userId: String, route: Route, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let routeRef = db.collection("routes").document(route.id.uuidString) // Save in top-level "routes"
            try routeRef.setData(from: route) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }

    
    // Fetch Routes
    static func fetchRoutes(forUser userId: String? = nil, completion: @escaping ([Route]) -> Void) {
        let db = Firestore.firestore()
        var query: Query = db.collection("routes") // Fetch from top-level "routes" collection
        
        if let userId = userId {
            query = query.whereField("userId", isEqualTo: userId)
        }
        
        query.getDocuments { snapshot, error in
            guard let documents = snapshot?.documents, error == nil else {
                print("Error fetching routes: \(error?.localizedDescription ?? "unknown error")")
                completion([])
                return
            }
            
            let routes = documents.compactMap { try? $0.data(as: Route.self) }
            completion(routes)
        }
    }
    
}
