import SwiftUI

struct SettingsView: View {
    @State private var preferences: UserPreferences?
    @State private var isLoading = true
    @State private var errorMessage: String?

    // Local state for editing (since we may not have full control over durations in API)
    @State private var autoSelectFavorites = false
    @State private var selectedGodName: String?

    var body: some View {
        ScrollView {
            if isLoading {
                ProgressView("Loading settings...")
                    .padding(.top, 100)
            } else if let error = errorMessage {
                VStack(spacing: 16) {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundStyle(.secondary)
                    Text(error)
                        .foregroundStyle(.secondary)
                    Button("Retry") {
                        Task { await loadData() }
                    }
                }
                .padding(.top, 100)
            } else {
                VStack(spacing: 32) {
                    // God preferences
                    godPreferencesSection

                    Divider()
                        .padding(.horizontal)

                    // Timer durations info
                    timerDurationsSection

                    Divider()
                        .padding(.horizontal)

                    // About section
                    aboutSection
                }
                .padding(.vertical, 24)
            }
        }
        .navigationTitle("Settings")
        .task {
            await loadData()
        }
    }

    private var godPreferencesSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("God Selection", icon: "person.fill.questionmark")

            VStack(spacing: 0) {
                // Auto-select favorites toggle
                Toggle(isOn: $autoSelectFavorites) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Auto-select from Favorites")
                            .font(.body)
                        Text("Randomly pick a favorite god for each session")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .toggleStyle(.switch)
                .padding()
                .onChange(of: autoSelectFavorites) { _, newValue in
                    Task {
                        await updateAutoSelectFavorites(newValue)
                    }
                }

                Divider()
                    .padding(.leading)

                // Current selected god
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Selected God")
                            .font(.body)
                        if let godName = selectedGodName {
                            Text(godName)
                                .font(.caption)
                                .foregroundStyle(Color.accentColor)
                        } else {
                            Text("None - using auto-select or random")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Spacer()

                    if selectedGodName != nil {
                        Button("Clear") {
                            Task {
                                await clearSelectedGod()
                            }
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.windowBackgroundColor))
            )
            .padding(.horizontal)
        }
    }

    private var timerDurationsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("Timer Durations", icon: "timer")

            VStack(spacing: 0) {
                durationRow(label: "Focus Session", value: "25 minutes")
                Divider().padding(.leading)
                durationRow(label: "Short Break", value: "5 minutes")
                Divider().padding(.leading)
                durationRow(label: "Long Break", value: "15 minutes")
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.windowBackgroundColor))
            )
            .padding(.horizontal)

            Text("Timer durations are currently fixed. Custom durations coming soon!")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    private func durationRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private var aboutSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            sectionHeader("About", icon: "info.circle")

            VStack(spacing: 0) {
                aboutRow(label: "App", value: "Pantheon Timer")
                Divider().padding(.leading)
                aboutRow(label: "Version", value: "1.0.0")
                Divider().padding(.leading)
                aboutRow(label: "Developer", value: "Ombori Hackathon Team")
            }
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(.windowBackgroundColor))
            )
            .padding(.horizontal)

            Text("A Pomodoro timer where Greek gods guide your productivity.")
                .font(.caption)
                .foregroundStyle(.secondary)
                .padding(.horizontal)
        }
    }

    private func aboutRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.body)
            Spacer()
            Text(value)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .padding()
    }

    private func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundStyle(Color.accentColor)
            Text(title)
                .font(.headline)
        }
        .padding(.horizontal)
    }

    private func loadData() async {
        isLoading = true
        errorMessage = nil

        do {
            let prefs = try await APIClient.shared.fetchPreferences()
            preferences = prefs
            autoSelectFavorites = prefs.autoSelectFavorites

            // Load selected god name if there is one
            if let godId = prefs.selectedGodId {
                let god = try await APIClient.shared.fetchGod(id: godId)
                selectedGodName = god.name
            } else {
                selectedGodName = nil
            }
        } catch {
            errorMessage = "Failed to load settings: \(error.localizedDescription)"
        }

        isLoading = false
    }

    private func updateAutoSelectFavorites(_ value: Bool) async {
        do {
            let update = UserPreferencesUpdate(autoSelectFavorites: value)
            preferences = try await APIClient.shared.updatePreferences(update)
        } catch {
            print("Failed to update auto-select: \(error)")
            // Revert on failure
            autoSelectFavorites = preferences?.autoSelectFavorites ?? false
        }
    }

    private func clearSelectedGod() async {
        do {
            preferences = try await APIClient.shared.setSelectedGod(godId: nil)
            selectedGodName = nil
        } catch {
            print("Failed to clear selected god: \(error)")
        }
    }
}
