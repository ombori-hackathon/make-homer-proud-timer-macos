import SwiftUI

struct GodDetailView: View {
    let god: God
    let onSelect: (God) -> Void
    @StateObject private var service = GodSelectionService()
    @State private var godStats: GodStats?
    @State private var isLoadingStats = true

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                // Hero section
                heroSection

                Divider()
                    .padding(.horizontal)

                // Coaching style
                coachingSection

                Divider()
                    .padding(.horizontal)

                // Sample messages
                messagesSection

                Divider()
                    .padding(.horizontal)

                // History with this god
                historySection

                // Select button
                selectButton
            }
            .padding(.vertical, 24)
        }
        .navigationTitle(god.name)
        .task {
            await loadData()
        }
    }

    private var heroSection: some View {
        VStack(spacing: 16) {
            // Large icon
            Image(systemName: god.icon)
                .font(.system(size: 72))
                .foregroundStyle(Color.accentColor)
                .frame(width: 120, height: 120)
                .background(
                    Circle()
                        .fill(Color.accentColor.opacity(0.1))
                )

            // Name
            Text(god.name)
                .font(.largeTitle)
                .fontWeight(.bold)

            // Domain
            Text(god.domain)
                .font(.title3)
                .foregroundStyle(.secondary)

            // Favorite button
            Button(action: {
                Task {
                    await service.toggleFavorite(god)
                }
            }) {
                HStack(spacing: 6) {
                    Image(systemName: service.isFavorite(god) ? "star.fill" : "star")
                    Text(service.isFavorite(god) ? "Favorited" : "Add to Favorites")
                }
                .foregroundStyle(service.isFavorite(god) ? .yellow : .secondary)
            }
            .buttonStyle(.plain)
        }
    }

    private var coachingSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            sectionHeader("Coaching Style", icon: "bubble.left.and.bubble.right.fill")

            Text(god.coachingStyle)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.windowBackgroundColor))
                )
        }
        .padding(.horizontal)
    }

    private var messagesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Focus Messages", icon: "brain.head.profile")

            VStack(alignment: .leading, spacing: 8) {
                ForEach(god.focusMessages.prefix(3), id: \.self) { message in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "quote.opening")
                            .font(.caption)
                            .foregroundStyle(Color.accentColor)
                        Text(message)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.windowBackgroundColor))
            )

            sectionHeader("Break Messages", icon: "cup.and.saucer.fill")

            VStack(alignment: .leading, spacing: 8) {
                ForEach(god.breakMessages.prefix(3), id: \.self) { message in
                    HStack(alignment: .top, spacing: 8) {
                        Image(systemName: "quote.opening")
                            .font(.caption)
                            .foregroundStyle(.green)
                        Text(message)
                            .font(.callout)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.windowBackgroundColor))
            )
        }
        .padding(.horizontal)
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
                        .foregroundStyle(.secondary)
                }
                .padding()
            } else if let stats = godStats {
                HStack(spacing: 24) {
                    statItem(value: "\(stats.sessionCount)", label: "sessions")
                    statItem(value: formatMinutes(stats.totalMinutes), label: "total")
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(.windowBackgroundColor))
                )
            } else {
                Text("No sessions yet with \(god.name)")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .padding()
            }
        }
        .padding(.horizontal)
    }

    private var selectButton: some View {
        Button(action: {
            onSelect(god)
        }) {
            HStack {
                Image(systemName: "checkmark.circle.fill")
                Text("Select \(god.name)")
            }
            .frame(maxWidth: 300)
            .padding()
            .background(Color.accentColor)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .padding(.horizontal)
        .padding(.top, 8)
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
            Text(title)
                .font(.headline)
        }
    }

    private func statItem(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
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

    private func loadData() async {
        await service.loadData()

        // Calculate god-specific stats
        do {
            let stats = try await APIClient.shared.fetchStats()
            let godName = god.name
            let sessionCount = stats.sessionsByGod[godName] ?? 0
            // Estimate minutes (25 min per session average)
            let totalMinutes = sessionCount * 25
            godStats = GodStats(sessionCount: sessionCount, totalMinutes: totalMinutes)
        } catch {
            print("Failed to load god stats: \(error)")
        }
        isLoadingStats = false
    }
}

struct GodStats {
    let sessionCount: Int
    let totalMinutes: Int
}
