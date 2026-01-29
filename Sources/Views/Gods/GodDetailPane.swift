import SwiftUI

/// Detail pane for god split-view (right side)
struct GodDetailPane: View {
    let god: God
    @ObservedObject var service: GodSelectionService
    let onSelect: (God) -> Void

    @State private var godStats: GodStats?
    @State private var isLoadingStats = true

    private var theme: GodTheme {
        GodTheme.forGod(named: god.name)
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Hero section
                heroSection

                Divider()
                    .background(HadesTheme.asphodelusGray)
                    .padding(.horizontal)

                // Coaching style
                coachingSection

                Divider()
                    .background(HadesTheme.asphodelusGray)
                    .padding(.horizontal)

                // Sample messages
                messagesSection

                Divider()
                    .background(HadesTheme.asphodelusGray)
                    .padding(.horizontal)

                // History section
                historySection

                // Select button
                selectButton
            }
            .padding(.vertical, 24)
        }
        .background(HadesTheme.underworldBlack)
        .task {
            await loadStats()
        }
        .onChange(of: god.id) { _, _ in
            isLoadingStats = true
            godStats = nil
            Task {
                await loadStats()
            }
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Large icon with themed background
            ZStack {
                Circle()
                    .fill(theme.primaryColor.opacity(0.15))
                    .frame(width: 120, height: 120)

                Image(systemName: god.icon)
                    .font(.system(size: 56))
                    .foregroundStyle(theme.primaryColor)
            }

            // Name
            Text(god.name)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(HadesTheme.primaryText)

            // Domain
            Text(god.domain)
                .font(.title3)
                .foregroundStyle(theme.primaryColor)

            // Favorite button
            Button {
                Task {
                    await service.toggleFavorite(god)
                }
            } label: {
                HStack(spacing: 6) {
                    Image(systemName: service.isFavorite(god) ? "star.fill" : "star")
                    Text(service.isFavorite(god) ? "Favorited" : "Add to Favorites")
                }
                .font(.subheadline)
                .foregroundStyle(service.isFavorite(god) ? .yellow : HadesTheme.secondaryText)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(HadesTheme.tartarusGray)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(
                            service.isFavorite(god) ? Color.yellow.opacity(0.3) : HadesTheme.asphodelusGray,
                            lineWidth: 1
                        )
                )
            }
            .buttonStyle(.plain)
        }
    }

    private var coachingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Coaching Style", icon: "bubble.left.and.bubble.right.fill")

            Text(god.coachingStyle)
                .font(.body)
                .foregroundStyle(HadesTheme.secondaryText)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .hadesCard(accent: theme.primaryColor)
        }
        .padding(.horizontal)
    }

    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Focus messages
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("Focus Messages", icon: "brain.head.profile")

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(god.focusMessages.prefix(3), id: \.self) { message in
                        messageRow(message, icon: "quote.opening", color: theme.primaryColor)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .hadesCard(accent: theme.primaryColor)
            }

            // Break messages
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader("Break Messages", icon: "cup.and.saucer.fill")

                VStack(alignment: .leading, spacing: 8) {
                    ForEach(god.breakMessages.prefix(3), id: \.self) { message in
                        messageRow(message, icon: "quote.opening", color: HadesTheme.successGreen)
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .hadesCard(accent: HadesTheme.successGreen)
            }
        }
        .padding(.horizontal)
    }

    private func messageRow(_ message: String, icon: String, color: Color) -> some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(message)
                .font(.callout)
                .foregroundStyle(HadesTheme.secondaryText)
        }
    }

    private var historySection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Your History", icon: "clock.fill")

            if isLoadingStats {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                    Text("Loading stats...")
                        .font(.caption)
                        .foregroundStyle(HadesTheme.secondaryText)
                }
                .padding()
            } else if let stats = godStats, stats.sessionCount > 0 {
                HStack(spacing: 32) {
                    statItem(value: "\(stats.sessionCount)", label: "sessions", color: theme.primaryColor)
                    statItem(value: formatMinutes(stats.totalMinutes), label: "total", color: theme.secondaryColor)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .hadesCard(accent: theme.primaryColor)
            } else {
                Text("No sessions yet with \(god.name)")
                    .font(.callout)
                    .foregroundStyle(HadesTheme.tertiaryText)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .hadesCard()
            }
        }
        .padding(.horizontal)
    }

    private var selectButton: some View {
        Button {
            onSelect(god)
        } label: {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Select \(god.name)")
            }
            .font(.headline)
            .foregroundStyle(.white)
            .frame(maxWidth: 300)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(theme.primaryColor)
                    .shadow(color: theme.primaryColor.opacity(0.4), radius: 8, x: 0, y: 4)
            )
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(theme.primaryColor)
            Text(title)
                .font(.headline)
                .foregroundStyle(HadesTheme.primaryText)
        }
    }

    private func statItem(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(color)
            Text(label)
                .font(.caption)
                .foregroundStyle(HadesTheme.secondaryText)
        }
    }

    private func formatMinutes(_ minutes: Int) -> String {
        if minutes < 60 {
            return "\(minutes)m"
        } else {
            let hours = minutes / 60
            let mins = minutes % 60
            return mins > 0 ? "\(hours)h \(mins)m" : "\(hours)h"
        }
    }

    private func loadStats() async {
        do {
            let stats = try await APIClient.shared.fetchStats()
            let sessionCount = stats.sessionsByGod[god.name] ?? 0
            let totalMinutes = sessionCount * 25  // Estimate
            godStats = GodStats(sessionCount: sessionCount, totalMinutes: totalMinutes)
        } catch {
            print("Failed to load god stats: \(error)")
        }
        isLoadingStats = false
    }
}
