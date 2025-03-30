//
//  ProfileViewModel.swift
//  Runner.io
//

import Foundation
import FirebaseFirestore

class ProfileViewModel: ObservableObject {
    @Published var userName: String = ""
    @Published var userEmail: String = ""
    @Published var routes: [Route] = []
    @Published var isLoading: Bool = true

    private let db = Firestore.firestore()

    // Fetch user profile and routes from Firestore
    func fetchUserData(userId: String) {
        isLoading = true

        fetchUserProfile(userId: userId) { [weak self] result in
            switch result {
            case .success(let user):
                DispatchQueue.main.async {
                    self?.userName = user.name
                    self?.userEmail = user.email

                    // Fetch routes after fetching the user profile
                    self?.fetchRoutes(userId: userId)
                }
            case .failure(let error):
                print("Error fetching user data: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
            }
        }
    }

    // MARK: - Fetch User Profile
    private func fetchUserProfile(userId: String, completion: @escaping (Result<User, Error>) -> Void) {
        db.collection("users").document(userId).getDocument { snapshot, error in
            guard let snapshot = snapshot, snapshot.exists, error == nil else {
                completion(.failure(error ?? NSError(domain: "FirestoreError", code: -1, userInfo: nil)))
                return
            }

            do {
                let user = try snapshot.data(as: User.self)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }
    }

    // MARK: - Fetch Routes
    private func fetchRoutes(userId: String) {
        db.collection("users").document(userId).collection("routes").getDocuments { [weak self] snapshot, error in
            if let error = error {
                print("Error fetching routes: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isLoading = false
                }
                return
            }

            guard let documents = snapshot?.documents else {
                DispatchQueue.main.async {
                    self?.routes = []
                    self?.isLoading = false
                }
                return
            }

            let fetchedRoutes = documents.compactMap { document -> Route? in
                try? document.data(as: Route.self)
            }

            DispatchQueue.main.async {
                self?.routes = fetchedRoutes
                self?.isLoading = false
            }
        }
    }
}
