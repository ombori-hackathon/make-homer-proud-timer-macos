import Foundation

struct Session: Codable, Identifiable {
    let id: Int
    let godId: Int
    let sessionType: String
    let durationSeconds: Int
    let startedAt: Date
    let completedAt: Date?
    let wasCompleted: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case godId = "god_id"
        case sessionType = "session_type"
        case durationSeconds = "duration_seconds"
        case startedAt = "started_at"
        case completedAt = "completed_at"
        case wasCompleted = "was_completed"
    }
}

struct TodaySessions: Codable {
    let count: Int
    let sessions: [Session]
}

struct SessionCreateRequest: Codable {
    let godId: Int
    let sessionType: String
    let durationSeconds: Int
    let startedAt: Date

    enum CodingKeys: String, CodingKey {
        case godId = "god_id"
        case sessionType = "session_type"
        case durationSeconds = "duration_seconds"
        case startedAt = "started_at"
    }
}

struct SessionCompleteRequest: Codable {
    let completedAt: Date?

    enum CodingKeys: String, CodingKey {
        case completedAt = "completed_at"
    }
}
