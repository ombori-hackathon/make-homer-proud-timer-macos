import SwiftUI

struct MainNavigationView: View {
    @EnvironmentObject var appState: AppStateService
    @State private var columnVisibility: NavigationSplitViewVisibility = .automatic

    private var currentTheme: GodTheme {
        appState.currentTheme
    }

    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            // Themed Sidebar
            VStack(spacing: 0) {
                // Current god indicator at top
                currentGodHeader
                    .padding(.bottom, 8)

                Divider()
                    .background(HadesTheme.asphodelusGray)

                // Navigation items
                VStack(spacing: 4) {
                    ForEach(NavigationTab.allCases) { tab in
                        ThemedNavigationRow(
                            tab: tab,
                            isSelected: appState.selectedTab == tab,
                            theme: currentTheme
                        ) {
                            appState.selectTab(tab)
                        }
                    }
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 8)

                Spacer()
            }
            .background(HadesTheme.sidebarBackground)
            .navigationSplitViewColumnWidth(min: 150, ideal: 200, max: 240)
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

    private var currentGodHeader: some View {
        VStack(spacing: 8) {
            if let god = appState.timerService.currentGod {
                // God icon
                Image(systemName: god.icon)
                    .font(.system(size: 28))
                    .foregroundStyle(currentTheme.primaryColor)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(currentTheme.primaryColor.opacity(0.15))
                    )

                // God name
                Text(god.name)
                    .font(.headline)
                    .foregroundStyle(HadesTheme.primaryText)

                // Domain
                Text(god.domain)
                    .font(.caption)
                    .foregroundStyle(currentTheme.primaryColor)
                    .lineLimit(1)
            } else {
                // No god selected state
                Image(systemName: "questionmark.circle")
                    .font(.system(size: 28))
                    .foregroundStyle(HadesTheme.tertiaryText)
                    .frame(width: 48, height: 48)
                    .background(
                        Circle()
                            .fill(HadesTheme.tartarusGray)
                    )

                Text("No God")
                    .font(.headline)
                    .foregroundStyle(HadesTheme.secondaryText)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
    }
}

/// Themed navigation row for sidebar
struct ThemedNavigationRow: View {
    let tab: NavigationTab
    let isSelected: Bool
    let theme: GodTheme
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: tab.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(isSelected ? theme.primaryColor : HadesTheme.secondaryText)
                    .frame(width: 24)

                Text(tab.rawValue)
                    .font(.subheadline)
                    .fontWeight(isSelected ? .semibold : .regular)
                    .foregroundStyle(isSelected ? HadesTheme.primaryText : HadesTheme.secondaryText)

                Spacer()

                // Selection indicator
                if isSelected {
                    RoundedRectangle(cornerRadius: 2)
                        .fill(theme.primaryColor)
                        .frame(width: 3, height: 16)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? HadesTheme.sidebarSelected : Color.clear)
            )
            .contentShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
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
