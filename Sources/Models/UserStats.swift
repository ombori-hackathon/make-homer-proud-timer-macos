import Foundation

struct UserStats: Codable {
    let id: Int
    let userId: String
    let totalSessions: Int
    let totalFocusMinutes: Int
    let currentStreak: Int
    let lastSessionDate: String?
    let sessionsByGod: [String: Int]

    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case totalSessions = "total_sessions"
        case totalFocusMinutes = "total_focus_minutes"
        case currentStreak = "current_streak"
        case lastSessionDate = "last_session_date"
        case sessionsByGod = "sessions_by_god"
    }
}
