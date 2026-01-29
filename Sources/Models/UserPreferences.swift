import Foundation

struct UserPreferences: Codable, Identifiable {
    let id: Int
    let userId: String
    let selectedGodId: Int?
    let favoriteGodIds: [Int]
    let autoSelectFavorites: Bool
    let createdAt: Date
    let updatedAt: Date

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case selectedGodId = "selected_god_id"
        case favoriteGodIds = "favorite_god_ids"
        case autoSelectFavorites = "auto_select_favorites"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

struct UserPreferencesUpdate: Codable {
    var selectedGodId: Int?
    var favoriteGodIds: [Int]?
    var autoSelectFavorites: Bool?

    enum CodingKeys: String, CodingKey {
        case selectedGodId = "selected_god_id"
        case favoriteGodIds = "favorite_god_ids"
        case autoSelectFavorites = "auto_select_favorites"
    }
}

struct FavoriteToggle: Codable {
    let godId: Int

    enum CodingKeys: String, CodingKey {
        case godId = "god_id"
    }
}

struct SelectedGodUpdate: Codable {
    let godId: Int?

    enum CodingKeys: String, CodingKey {
        case godId = "god_id"
    }
}
