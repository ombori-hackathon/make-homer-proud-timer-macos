import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var appState: AppStateService
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Sidebar
            List(NavigationTab.allCases, selection: $appState.selectedTab) { tab in
                NavigationLink(value: tab) {
                    Label(tab.rawValue, systemImage: tab.icon)
                }
            }
            .navigationSplitViewColumnWidth(min: 150, ideal: 180, max: 220)
            .listStyle(.sidebar)
        } detail: {
            // Content area
            Group {
                switch appState.selectedTab {
                case .timer:
                    TimerScreen()
                case .stats:
                    StatsView()
                case .settings:
                    SettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 600, minHeight: 500)
        // Keyboard shortcuts
        .keyboardShortcut("1", modifiers: .command) {
            appState.selectTab(.timer)
        }
        .keyboardShortcut("2", modifiers: .command) {
            appState.selectTab(.stats)
        }
        .keyboardShortcut("3", modifiers: .command) {
            appState.selectTab(.settings)
        }
    }
}

// Custom keyboard shortcut modifier
extension View {
    func keyboardShortcut(_ key: KeyEquivalent, modifiers: EventModifiers, action: @escaping () -> Void) -> some View {
        self.background(
            Button("") { action() }
                .keyboardShortcut(key, modifiers: modifiers)
                .opacity(0)
        )
    }
}
