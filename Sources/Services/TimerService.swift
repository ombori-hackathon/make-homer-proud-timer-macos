import Foundation
import Combine

@MainActor
class TimerService: ObservableObject {
    @Published var state: TimerState = .stopped
    @Published var timeRemaining: Int
    @Published var sessionType: SessionType = .focus
    @Published var currentGod: God?
    @Published var todaySessionCount: Int = 0
    @Published var currentMessage: String = ""
    @Published var currentSessionId: Int?

    private var timer: Timer?
    private var sessionStartedAt: Date?

    var progress: Double {
        let total = Double(sessionType.defaultDuration)
        let remaining = Double(timeRemaining)
        return 1.0 - (remaining / total)
    }

    var timeString: String {
        let minutes = timeRemaining / 60
        let seconds = timeRemaining % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }

    init() {
        timeRemaining = SessionType.focus.defaultDuration
    }

    func loadRandomGod() async {
        do {
            let gods = try await APIClient.shared.fetchGods()
            if let randomGod = gods.randomElement() {
                currentGod = randomGod
                currentMessage = randomGod.randomStartMessage()
            }
        } catch {
            print("Failed to load gods: \(error)")
        }
    }

    func loadGodFromPreferences() async {
        do {
            let preferences = try await APIClient.shared.fetchPreferences()

            // If a god is selected, use that
            if let selectedGodId = preferences.selectedGodId {
                let god = try await APIClient.shared.fetchGod(id: selectedGodId)
                currentGod = god
                currentMessage = god.randomStartMessage()
                return
            }

            // If auto-select favorites and there are favorites, pick random
            if preferences.autoSelectFavorites && !preferences.favoriteGodIds.isEmpty {
                let randomFavoriteId = preferences.favoriteGodIds.randomElement()!
                let god = try await APIClient.shared.fetchGod(id: randomFavoriteId)
                currentGod = god
                currentMessage = god.randomStartMessage()
                return
            }

            // Otherwise, load a random god
            await loadRandomGod()
        } catch {
            print("Failed to load preferences: \(error)")
            // Fall back to random god
            await loadRandomGod()
        }
    }

    func setCurrentGod(_ god: God) {
        currentGod = god
        currentMessage = god.randomStartMessage()
    }

    func loadTodaySessions() async {
        do {
            let today = try await APIClient.shared.fetchTodaySessions()
            todaySessionCount = today.count
        } catch {
            print("Failed to load today's sessions: \(error)")
        }
    }

    func start() {
        guard state.canStart else { return }

        if state == .stopped {
            // Fresh start - create session
            sessionStartedAt = Date()
            Task {
                await createSessionOnServer()
            }
        }

        state = .running

        if let god = currentGod {
            currentMessage = god.randomMessage(for: sessionType)
        }

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor [weak self] in
                self?.tick()
            }
        }
    }

    func pause() {
        guard state.canPause else { return }
        state = .paused
        timer?.invalidate()
        timer = nil
        currentMessage = "Paused. Ready when you are."
    }

    func reset() {
        state = .stopped
        timer?.invalidate()
        timer = nil
        timeRemaining = sessionType.defaultDuration
        currentSessionId = nil
        sessionStartedAt = nil

        if let god = currentGod {
            currentMessage = god.randomStartMessage()
        }
    }

    func setSessionType(_ type: SessionType) {
        guard state == .stopped else { return }
        sessionType = type
        timeRemaining = type.defaultDuration
    }

    private func tick() {
        guard timeRemaining > 0 else {
            completeSession()
            return
        }
        timeRemaining -= 1

        // Update message occasionally
        if timeRemaining % 300 == 0 && timeRemaining > 0 {
            if let god = currentGod {
                currentMessage = god.randomMessage(for: sessionType)
            }
        }
    }

    private func completeSession() {
        timer?.invalidate()
        timer = nil
        state = .stopped

        Task {
            await markSessionCompleteOnServer()
            await loadTodaySessions()
        }

        // Switch to next session type
        switch sessionType {
        case .focus:
            // Every 4 focus sessions, take a long break
            if (todaySessionCount + 1) % 4 == 0 {
                sessionType = .longBreak
            } else {
                sessionType = .shortBreak
            }
            currentMessage = "Great work! Time for a break."
        case .shortBreak, .longBreak:
            sessionType = .focus
            if let god = currentGod {
                currentMessage = god.randomStartMessage()
            }
        }

        timeRemaining = sessionType.defaultDuration
    }

    private func createSessionOnServer() async {
        guard let god = currentGod, let startedAt = sessionStartedAt else { return }

        do {
            let session = try await APIClient.shared.createSession(
                godId: god.id,
                sessionType: sessionType,
                durationSeconds: sessionType.defaultDuration,
                startedAt: startedAt
            )
            currentSessionId = session.id
        } catch {
            print("Failed to create session: \(error)")
        }
    }

    private func markSessionCompleteOnServer() async {
        guard let sessionId = currentSessionId else { return }

        do {
            _ = try await APIClient.shared.completeSession(id: sessionId)
        } catch {
            print("Failed to complete session: \(error)")
        }
    }
}
