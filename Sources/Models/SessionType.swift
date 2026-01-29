import Foundation

enum SessionType: String, Codable, CaseIterable {
    case focus = "focus"
    case shortBreak = "short_break"
    case longBreak = "long_break"

    var displayName: String {
        switch self {
        case .focus:
            return "Focus"
        case .shortBreak:
            return "Short Break"
        case .longBreak:
            return "Long Break"
        }
    }

    var defaultDuration: Int {
        switch self {
        case .focus:
            return 25 * 60  // 25 minutes
        case .shortBreak:
            return 5 * 60   // 5 minutes
        case .longBreak:
            return 15 * 60  // 15 minutes
        }
    }

    /// API value (focus/break)
    var apiValue: String {
        switch self {
        case .focus:
            return "focus"
        case .shortBreak, .longBreak:
            return "break"
        }
    }
}
