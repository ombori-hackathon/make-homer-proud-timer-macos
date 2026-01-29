import SwiftUI

struct TimerScreen: View {
    @EnvironmentObject var appState: AppStateService
    @State private var navigationPath = NavigationPath()

    var body: some View {
        NavigationStack(path: $navigationPath) {
            TimerContentView(navigationPath: $navigationPath)
                .environmentObject(appState.timerService)
        }
    }
}

struct TimerContentView: View {
    @EnvironmentObject var timerService: TimerService
    @Binding var navigationPath: NavigationPath

    var body: some View {
        VStack(spacing: 24) {
            // Top bar with god and stats
            HStack {
                GodAvatarView(god: timerService.currentGod, onTap: {
                    navigationPath.append(GodNavigation.list)
                })

                Spacer()

                StatsWidgetView(todayCount: timerService.todaySessionCount)
            }
            .padding(.horizontal)

            Spacer()

            // Session type selector
            SessionTypeIndicator(
                sessionType: timerService.sessionType,
                isDisabled: timerService.state != .stopped,
                onSelect: { type in
                    timerService.setSessionType(type)
                }
            )

            // Timer display
            CircularProgressView(
                progress: timerService.progress,
                timeString: timerService.timeString,
                sessionType: timerService.sessionType
            )

            // God's message
            Text(timerService.currentMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .padding(.horizontal)

            // Controls
            TimerControlsView(
                state: timerService.state,
                onStart: { timerService.start() },
                onPause: { timerService.pause() },
                onReset: { timerService.reset() }
            )

            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
        .task {
            await timerService.loadGodFromPreferences()
            await timerService.loadTodaySessions()
        }
        .navigationDestination(for: GodNavigation.self) { destination in
            switch destination {
            case .list:
                GodListView(onGodSelected: { god in
                    timerService.setCurrentGod(god)
                    navigationPath.removeLast()
                }, navigationPath: $navigationPath)
            case .detail(let god):
                GodDetailView(god: god, onSelect: { selectedGod in
                    timerService.setCurrentGod(selectedGod)
                    navigationPath = NavigationPath()
                })
            }
        }
    }
}

enum GodNavigation: Hashable {
    case list
    case detail(God)
}

extension God: Hashable {
    static func == (lhs: God, rhs: God) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
