import SwiftUI

struct StatsView: View {
    @EnvironmentObject var appState: AppStateService
    @State private var stats: UserStats?
    @State private var recentSessions: [Session] = []
    @State private var gods: [God] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    private var currentTheme: GodTheme {
        appState.currentTheme
    }

    var body: some View {
        ZStack {
            // Dark background with subtle pattern
            HadesTheme.underworldBlack
                .ignoresSafeArea()

            GeometricPatternView(theme: currentTheme, opacity: 0.02)

            ScrollView {
                if isLoading {
                    VStack(spacing: 16) {
                        ProgressView()
                            .scaleEffect(1.2)
                        Text("Loading statistics...")
                            .font(.subheadline)
                            .foregroundStyle(HadesTheme.secondaryText)
                    }
                    .padding(.top, 100)
                } else if let error = errorMessage {
                    VStack(spacing: 16) {
                        Image(systemName: "exclamationmark.triangle")
                            .font(.largeTitle)
                            .foregroundStyle(HadesTheme.warningOrange)
                        Text(error)
                            .foregroundStyle(HadesTheme.secondaryText)
                        Button("Retry") {
                            Task { await loadData() }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(currentTheme.primaryColor)
                    }
                    .padding(.top, 100)
                } else if let stats = stats {
                    VStack(spacing: 32) {
                        // Summary cards
                        summaryCards(stats: stats)

                        Divider()
                            .background(HadesTheme.asphodelusGray)
                            .padding(.horizontal)

                        // Sessions by god
                        godBreakdown(stats: stats)

                        Divider()
                            .background(HadesTheme.asphodelusGray)
                            .padding(.horizontal)

                        // Recent sessions
                        recentSessionsList
                    }
                    .padding(.vertical, 24)
                }
            }
        }
        .navigationTitle("Statistics")
        .task {
            await loadData()
        }
    }

    private func summaryCards(stats: UserStats) -> some View {
        HStack(spacing: 16) {
            summaryCard(
                value: "\(stats.totalSessions)",
                label: "Sessions",
                icon: "checkmark.circle.fill",
                color: currentTheme.primaryColor
            )

            summaryCard(
                value: formatMinutes(stats.totalFocusMinutes),
                label: "Focus Time",
                icon: "brain.head.profile",
                color: currentTheme.secondaryColor
            )

            summaryCard(
                value: "\(stats.currentStreak)",
                label: "Day Streak",
                icon: "flame.fill",
                color: HadesTheme.warningOrange
            )
        }
        .padding(.horizontal)
    }

    private func summaryCard(value: String, label: String, icon: String, color: Color) -> some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title)
                .foregroundStyle(color)

            Text(value)
                .font(.title)
                .fontWeight(.bold)
                .foregroundStyle(HadesTheme.primaryText)

            Text(label)
                .font(.caption)
                .foregroundStyle(HadesTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(HadesTheme.tartarusGray)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(color.opacity(0.3), lineWidth: 1)
        )
    }

    private func godBreakdown(stats: UserStats) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "person.3.fill")
                    .foregroundStyle(currentTheme.primaryColor)
                Text("Sessions by God")
                    .font(.headline)
                    .foregroundStyle(HadesTheme.primaryText)
            }
            .padding(.horizontal)

            if stats.sessionsByGod.isEmpty {
                Text("Complete sessions to see your breakdown")
                    .font(.callout)
                    .foregroundStyle(HadesTheme.secondaryText)
                    .padding(.horizontal)
            } else {
                VStack(spacing: 12) {
                    let sortedGods = stats.sessionsByGod.sorted { $0.value > $1.value }
                    let maxSessions = sortedGods.first?.value ?? 1

                    ForEach(sortedGods.prefix(5), id: \.key) { godName, count in
                        godProgressRow(
                            name: godName,
                            count: count,
                            maxCount: maxSessions,
                            icon: iconForGod(godName)
                        )
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(HadesTheme.tartarusGray)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(currentTheme.primaryColor.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }

    private func godProgressRow(name: String, count: Int, maxCount: Int, icon: String) -> some View {
        let godTheme = GodTheme.forGod(named: name)

        return HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(godTheme.primaryColor)
                .frame(width: 24)

            Text(name)
                .font(.body)
                .foregroundStyle(HadesTheme.primaryText)

            Spacer()

            GeometryReader { geometry in
                let width = geometry.size.width
                let progress = CGFloat(count) / CGFloat(maxCount)

                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(HadesTheme.asphodelusGray)
                        .frame(height: 8)

                    RoundedRectangle(cornerRadius: 4)
                        .fill(godTheme.primaryColor)
                        .frame(width: width * progress, height: 8)
                }
            }
            .frame(width: 100, height: 8)

            Text("\(count)")
                .font(.callout)
                .fontWeight(.medium)
                .foregroundStyle(HadesTheme.primaryText)
                .frame(width: 30, alignment: .trailing)
        }
    }

    private var recentSessionsList: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "clock.fill")
                    .foregroundStyle(currentTheme.primaryColor)
                Text("Recent Sessions")
                    .font(.headline)
                    .foregroundStyle(HadesTheme.primaryText)
            }
            .padding(.horizontal)

            if recentSessions.isEmpty {
                Text("No recent sessions")
                    .font(.callout)
                    .foregroundStyle(HadesTheme.secondaryText)
                    .padding(.horizontal)
            } else {
                VStack(spacing: 8) {
                    ForEach(recentSessions.prefix(10)) { session in
                        sessionRow(session)
                    }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(HadesTheme.tartarusGray)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(currentTheme.primaryColor.opacity(0.2), lineWidth: 1)
                )
                .padding(.horizontal)
            }
        }
    }

    private func sessionRow(_ session: Session) -> some View {
        HStack {
            Image(systemName: session.wasCompleted ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(session.wasCompleted ? HadesTheme.successGreen : HadesTheme.tertiaryText)

            Text(formatSessionType(session.sessionType))
                .font(.callout)
                .foregroundStyle(HadesTheme.primaryText)

            Spacer()

            Text(formatDuration(session.durationSeconds))
                .font(.caption)
                .foregroundStyle(HadesTheme.secondaryText)

            Text(formatDate(session.startedAt))
                .font(.caption)
                .foregroundStyle(HadesTheme.tertiaryText)
        }
        .padding(.vertical, 4)
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            return "\(hours)h"
        }
    }

    private func formatDuration(_ seconds: Int) -> String {
        let minutes = seconds / 60
        return "\(minutes)min"
    }

    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Today"
        } else if calendar.isDateInYesterday(date) {
            return "Yesterday"
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM d"
            return formatter.string(from: date)
        }
    }

    private func formatSessionType(_ type: String) -> String {
        switch type {
        case "focus": return "Focus"
        case "short_break": return "Short Break"
        case "long_break": return "Long Break"
        default: return type.capitalized
        }
    }

    private func iconForGod(_ name: String) -> String {
        // Find matching god from loaded gods
        if let god = gods.first(where: { $0.name == name }) {
            return god.icon
        }
        // Default icons for known gods
        switch name {
        case "Zeus": return "bolt.fill"
        case "Athena": return "brain.head.profile"
        case "Apollo": return "sun.max.fill"
        case "Ares": return "shield.fill"
        case "Hera": return "crown.fill"
        case "Poseidon": return "water.waves"
        case "Demeter": return "leaf.fill"
        case "Dionysus": return "wineglass.fill"
        case "Hephaestus": return "hammer.fill"
        case "Aphrodite": return "heart.fill"
        case "Hermes": return "figure.run"
        case "Artemis": return "moon.fill"
        default: return "person.fill"
        }
    }

    private func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            async let statsResult = APIClient.shared.fetchStats()
            async let todayResult = APIClient.shared.fetchTodaySessions()
            async let godsResult = APIClient.shared.fetchGods()

            stats = try await statsResult
            let todaySessions = try await todayResult
            recentSessions = todaySessions.sessions
            gods = try await godsResult
        } catch {
            errorMessage = "Failed to load statistics: \(error.localizedDescription)"
        }

        isLoading = false
    }
}
