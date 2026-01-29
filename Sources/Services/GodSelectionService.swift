import Foundation

@MainActor
class GodSelectionService: ObservableObject {
    @Published var gods: [God] = []
    @Published var preferences: UserPreferences?
    @Published var isLoading = false

    var favoriteGods: [God] {
        guard let prefs = preferences else { return [] }
        return gods.filter { prefs.favoriteGodIds.contains($0.id) }
    }

    var nonFavoriteGods: [God] {
        guard let prefs = preferences else { return gods }
        return gods.filter { !prefs.favoriteGodIds.contains($0.id) }
    }

    var selectedGod: God? {
        guard let prefs = preferences, let selectedId = prefs.selectedGodId else { return nil }
        return gods.first { $0.id == selectedId }
    }

    func loadData() async {
        isLoading = true
        defer { isLoading = false }

        do {
            async let godsResult = APIClient.shared.fetchGods()
            async let prefsResult = APIClient.shared.fetchPreferences()

            gods = try await godsResult
            preferences = try await prefsResult
        } catch {
            print("Failed to load god selection data: \(error)")
        }
    }

    func toggleFavorite(_ god: God) async {
        do {
            preferences = try await APIClient.shared.toggleFavorite(godId: god.id)
        } catch {
            print("Failed to toggle favorite: \(error)")
        }
    }

    func selectGod(_ god: God) async {
        do {
            preferences = try await APIClient.shared.setSelectedGod(godId: god.id)
        } catch {
            print("Failed to select god: \(error)")
        }
    }

    func clearSelection() async {
        do {
            preferences = try await APIClient.shared.setSelectedGod(godId: nil)
        } catch {
            print("Failed to clear selection: \(error)")
        }
    }

    func isFavorite(_ god: God) -> Bool {
        preferences?.favoriteGodIds.contains(god.id) ?? false
    }

    func isSelected(_ god: God) -> Bool {
        preferences?.selectedGodId == god.id
    }

    /// Returns a god for the next session based on preferences
    func getGodForSession() -> God? {
        if let selected = selectedGod {
            return selected
        }

        // If auto-select favorites is enabled and there are favorites, pick random from favorites
        if let prefs = preferences, prefs.autoSelectFavorites, !favoriteGods.isEmpty {
            return favoriteGods.randomElement()
        }

        // Otherwise pick from all gods
        return gods.randomElement()
    }
}
