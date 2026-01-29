import Foundation

enum APIError: Error, LocalizedError {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case unknown

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Decoding error: \(error.localizedDescription)"
        case .serverError(let code):
            return "Server error: \(code)"
        case .unknown:
            return "Unknown error"
        }
    }
}

actor APIClient {
    static let shared = APIClient()

    private let baseURL = "http://localhost:8000"
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder

    private init() {
        decoder = JSONDecoder()
        // Use custom date formatter that handles fractional seconds
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            if let date = formatter.date(from: dateString) {
                return date
            }
            // Fallback for dates without fractional seconds
            let fallbackFormatter = ISO8601DateFormatter()
            fallbackFormatter.formatOptions = [.withInternetDateTime]
            if let date = fallbackFormatter.date(from: dateString) {
                return date
            }
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode date: \(dateString)")
        }

        encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
    }

    // MARK: - Gods

    func fetchGods() async throws -> [God] {
        let url = URL(string: "\(baseURL)/gods")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode([God].self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchGod(id: Int) async throws -> God {
        let url = URL(string: "\(baseURL)/gods/\(id)")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(God.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Sessions

    func createSession(godId: Int, sessionType: SessionType, durationSeconds: Int, startedAt: Date) async throws -> Session {
        let url = URL(string: "\(baseURL)/sessions")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SessionCreateRequest(
            godId: godId,
            sessionType: sessionType.apiValue,
            durationSeconds: durationSeconds,
            startedAt: startedAt
        )
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 || httpResponse.statusCode == 201 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(Session.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func completeSession(id: Int) async throws -> Session {
        let url = URL(string: "\(baseURL)/sessions/\(id)/complete")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SessionCompleteRequest(completedAt: Date())
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(Session.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func fetchTodaySessions() async throws -> TodaySessions {
        let url = URL(string: "\(baseURL)/sessions/today")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(TodaySessions.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Stats

    func fetchStats() async throws -> UserStats {
        let url = URL(string: "\(baseURL)/stats")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(UserStats.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Preferences

    func fetchPreferences() async throws -> UserPreferences {
        let url = URL(string: "\(baseURL)/preferences")!
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(UserPreferences.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func updatePreferences(_ update: UserPreferencesUpdate) async throws -> UserPreferences {
        let url = URL(string: "\(baseURL)/preferences")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try encoder.encode(update)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(UserPreferences.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func toggleFavorite(godId: Int) async throws -> UserPreferences {
        let url = URL(string: "\(baseURL)/preferences/favorites")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = FavoriteToggle(godId: godId)
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(UserPreferences.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    func setSelectedGod(godId: Int?) async throws -> UserPreferences {
        let url = URL(string: "\(baseURL)/preferences/selected-god")!
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let body = SelectedGodUpdate(godId: godId)
        request.httpBody = try encoder.encode(body)

        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.unknown
        }

        guard httpResponse.statusCode == 200 else {
            throw APIError.serverError(httpResponse.statusCode)
        }

        do {
            return try decoder.decode(UserPreferences.self, from: data)
        } catch {
            throw APIError.decodingError(error)
        }
    }

    // MARK: - Health Check

    func checkHealth() async throws -> Bool {
        let url = URL(string: "\(baseURL)/health")!
        let (_, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }

        return httpResponse.statusCode == 200
    }
}
