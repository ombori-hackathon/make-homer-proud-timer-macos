import Foundation

enum TimerState: Equatable {
    case stopped
    case running
    case paused

    var isActive: Bool {
        self == .running
    }

    var canStart: Bool {
        self != .running
    }

    var canPause: Bool {
        self == .running
    }

    var canReset: Bool {
        self != .stopped
    }
}
