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
    @State private var messageChangeCounter = 0

    private var currentTheme: GodTheme {
        if let god = timerService.currentGod {
            return GodTheme.forGod(named: god.name)
        }
        return .default
    }

    var body: some View {
        ZStack {
            // Themed background
            currentTheme.backgroundColor
                .ignoresSafeArea()

            // Geometric pattern overlay
            AnimatedGeometricPatternView(theme: currentTheme)

            // Main content
            VStack(spacing: 20) {
                // Top bar with god icon and stats
                HStack(alignment: .top) {
                    // God icon (tappable)
                    Button {
                        navigationPath.append(GodNavigation.list)
                    } label: {
                        if let god = timerService.currentGod {
                            GodIconView(godName: god.name, size: 60)
                        } else {
                            GodIconView(godName: "default", size: 60)
                        }
                    }
                    .buttonStyle(.plain)

                    Spacer()

                    // Stats widget with theme colors
                    ThemedStatsWidget(
                        todayCount: timerService.todaySessionCount,
                        theme: currentTheme
                    )
                }
                .padding(.horizontal, 24)
                .padding(.top, 16)

                Spacer()

                // Session type selector
                ThemedSessionTypeIndicator(
                    sessionType: timerService.sessionType,
                    isDisabled: timerService.state != .stopped,
                    theme: currentTheme,
                    onSelect: { type in
                        timerService.setSessionType(type)
                    }
                )

                // Timer display with theme
                ThemedCircularProgress(
                    progress: timerService.progress,
                    timeString: timerService.timeString,
                    theme: currentTheme
                )

                // God's message bubble
                if let god = timerService.currentGod {
                    GodMessageBubble(
                        message: timerService.currentMessage,
                        godName: god.name,
                        theme: currentTheme
                    )
                    .padding(.horizontal, 24)
                    .id(messageChangeCounter)
                }

                // Controls with theme
                ThemedTimerControls(
                    state: timerService.state,
                    theme: currentTheme,
                    onStart: { timerService.start() },
                    onPause: { timerService.pause() },
                    onReset: { timerService.reset() }
                )

                Spacer()
            }
            .padding()
        }
        .frame(minWidth: 400, minHeight: 550)
        .animation(.easeInOut(duration: 0.5), value: timerService.currentGod?.id)
        .task {
            await timerService.loadGodFromPreferences()
            await timerService.loadTodaySessions()
        }
        .onChange(of: timerService.currentMessage) { _, _ in
            messageChangeCounter += 1
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

// MARK: - Themed Components

/// Stats widget with god theme colors
struct ThemedStatsWidget: View {
    let todayCount: Int
    let theme: GodTheme

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: "flame.fill")
                .foregroundStyle(theme.primaryColor)
            Text("\(todayCount)")
                .font(.headline)
                .foregroundStyle(theme.textColor)
            Text("today")
                .font(.caption)
                .foregroundStyle(theme.textColor.opacity(0.7))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.8))
                .shadow(color: theme.primaryColor.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

/// Session type indicator with theme
struct ThemedSessionTypeIndicator: View {
    let sessionType: SessionType
    let isDisabled: Bool
    let theme: GodTheme
    let onSelect: (SessionType) -> Void

    var body: some View {
        HStack(spacing: 8) {
            ForEach([SessionType.focus, .shortBreak, .longBreak], id: \.self) { type in
                Button {
                    onSelect(type)
                } label: {
                    Text(type.displayName)
                        .font(.caption)
                        .fontWeight(sessionType == type ? .bold : .regular)
                        .foregroundStyle(sessionType == type ? Color.white : theme.textColor)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(sessionType == type ? theme.primaryColor : Color.white.opacity(0.6))
                        )
                }
                .buttonStyle(.plain)
                .disabled(isDisabled)
                .opacity(isDisabled && sessionType != type ? 0.5 : 1)
            }
        }
    }
}

/// Circular progress with theme colors
struct ThemedCircularProgress: View {
    let progress: Double
    let timeString: String
    let theme: GodTheme

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .stroke(theme.primaryColor.opacity(0.2), lineWidth: 12)
                .frame(width: 200, height: 200)

            // Progress arc
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    theme.primaryColor,
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.3), value: progress)

            // Time text
            Text(timeString)
                .font(.system(size: 48, weight: .bold, design: .rounded))
                .foregroundStyle(theme.textColor)
        }
    }
}

/// Timer controls with theme
struct ThemedTimerControls: View {
    let state: TimerState
    let theme: GodTheme
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            // Reset button
            Button(action: onReset) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .foregroundStyle(theme.textColor.opacity(0.7))
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.6))
                    )
            }
            .buttonStyle(.plain)
            .opacity(state == .stopped ? 0.5 : 1)
            .disabled(state == .stopped)

            // Main play/pause button
            Button(action: {
                if state == .running {
                    onPause()
                } else {
                    onStart()
                }
            }) {
                Image(systemName: state == .running ? "pause.fill" : "play.fill")
                    .font(.title)
                    .foregroundStyle(Color.white)
                    .frame(width: 70, height: 70)
                    .background(
                        Circle()
                            .fill(theme.primaryColor)
                            .shadow(color: theme.primaryColor.opacity(0.4), radius: 8, x: 0, y: 4)
                    )
            }
            .buttonStyle(.plain)
            .scaleEffect(state == .running ? 1.0 : 1.05)
            .animation(.easeInOut(duration: 0.2), value: state)
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
