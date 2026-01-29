import Foundation
import SwiftUI
import Combine

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

    private var cancellables = Set<AnyCancellable>()

    init() {
        timerService = TimerService()

        // Forward timerService changes to trigger AppStateService updates
        // This ensures sidebar and other views react to nested state changes
        timerService.objectWillChange
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    /// Current god's theme for app-wide access
    var currentTheme: GodTheme {
        GodTheme.forGod(named: timerService.currentGod?.name ?? "default")
    }

    func selectTab(_ tab: NavigationTab) {
        selectedTab = tab
    }
}
