//
//  FirestoreManager.swift
//  Runner.io
//

import FirebaseFirestore

class FirestoreManager {
    private static let db = Firestore.firestore()

    // Save a route to Firestore
    static func saveRoute(userId: String, route: Route, completion: @escaping (Result<Void, Error>) -> Void) {
        do {
            let routeRef = db.collection("users").document(userId).collection("routes").document(route.id.uuidString)
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
    static func fetchRoutes(userId: String, completion: @escaping (Result<[Route], Error>) -> Void) {
        db.collection("users").document(userId).collection("routes").getDocuments { snapshot, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let documents = snapshot?.documents else {
                completion(.success([]))
                return
            }

            let routes = documents.compactMap { document -> Route? in
                try? document.data(as: Route.self)
            }
            completion(.success(routes))
        }
    }
}
