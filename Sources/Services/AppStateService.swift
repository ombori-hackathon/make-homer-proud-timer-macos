import Foundation
import SwiftUI

enum NavigationTab: String, CaseIterable, Identifiable {
    case timer = "Timer"
    case stats = "Stats"
    case settings = "Settings"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .timer: return "timer"
        case .stats: return "chart.bar.fill"
        case .settings: return "gear"
        }
    }

    var keyboardShortcut: KeyEquivalent {
        switch self {
        case .timer: return "1"
        case .stats: return "2"
        case .settings: return "3"
        }
    }
}

@MainActor
class AppStateService: ObservableObject {
    @Published var selectedTab: NavigationTab = .timer
    @Published var timerService: TimerService

    init() {
        timerService = TimerService()
    }

    func selectTab(_ tab: NavigationTab) {
        selectedTab = tab
    }
}
