import Foundation

struct User: Identifiable, Codable {
    let id: String // Firestore document ID
    let name: String
    let email: String
    let profileImageUrl: String? // Optional, can be nil if no profile image
    let dateOfBirth: Date? // Optional, can be nil if not provided
    let totalDistanceRun: Double // Total distance in kilometers (or miles)
    let achievements: [String] // List of achievement IDs or names
    let friends: [String] // List of friend user IDs
    let createdAt: Date // Timestamp for when the user was created
    let updatedAt: Date // Timestamp for when the user was last updated

    // MARK: - Custom Coding Keys (if Firestore keys differ)
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case profileImageUrl
        case dateOfBirth
        case totalDistanceRun
        case achievements
        case friends
        case createdAt
        case updatedAt
    }

    // MARK: - Initializer for Firestore Decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        email = try container.decode(String.self, forKey: .email)
        profileImageUrl = try container.decodeIfPresent(String.self, forKey: .profileImageUrl)
        dateOfBirth = try container.decodeIfPresent(Date.self, forKey: .dateOfBirth)
        totalDistanceRun = try container.decode(Double.self, forKey: .totalDistanceRun)
        achievements = try container.decode([String].self, forKey: .achievements)
        friends = try container.decode([String].self, forKey: .friends)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }

    // MARK: - Initializer for Manual Creation
    init(id: String, name: String, email: String, profileImageUrl: String? = nil, dateOfBirth: Date? = nil, totalDistanceRun: Double = 0.0, achievements: [String] = [], friends: [String] = [], createdAt: Date = Date(), updatedAt: Date = Date()) {
        self.id = id
        self.name = name
        self.email = email
        self.profileImageUrl = profileImageUrl
        self.dateOfBirth = dateOfBirth
        self.totalDistanceRun = totalDistanceRun
        self.achievements = achievements
        self.friends = friends
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
