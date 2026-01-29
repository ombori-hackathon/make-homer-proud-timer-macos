import Foundation

struct God: Codable, Identifiable {
    let id: Int
    let name: String
    let domain: String
    let icon: String
    let coachingStyle: String
    let focusMessages: [String]
    let breakMessages: [String]
    let sessionStartMessages: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, domain, icon
        case coachingStyle = "coaching_style"
        case focusMessages = "focus_messages"
        case breakMessages = "break_messages"
        case sessionStartMessages = "session_start_messages"
    }

    /// Returns a random message for the current session type
    func randomMessage(for sessionType: SessionType) -> String {
        let messages: [String]
        switch sessionType {
        case .focus:
            messages = focusMessages
        case .shortBreak, .longBreak:
            messages = breakMessages
        }
        return messages.randomElement() ?? "Keep going!"
    }

    /// Returns a random session start message
    func randomStartMessage() -> String {
        sessionStartMessages.randomElement() ?? "Let's begin!"
    }
}
