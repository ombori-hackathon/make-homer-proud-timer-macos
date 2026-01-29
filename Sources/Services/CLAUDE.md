# Swift Services

## APIClient
- Use `actor` for thread-safe singleton
- All methods are `async throws`
- Base URL: `http://localhost:8000`
- Use `URLSession.shared` for requests
- Encode/decode with `JSONEncoder`/`JSONDecoder`

## Example
```swift
actor APIClient {
    static let shared = APIClient()
    private let baseURL = "http://localhost:8000"

    func fetchGods() async throws -> [God] {
        let url = URL(string: "\(baseURL)/gods")!
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONDecoder().decode([God].self, from: data)
    }
}
```

## TimerService
- Use `@MainActor class` with `ObservableObject`
- Published properties: state, timeRemaining, progress, sessionType
- Timer uses `Timer.scheduledTimer` with 1-second interval
- Always update UI on main thread

## Example
```swift
@MainActor
class TimerService: ObservableObject {
    @Published var timeRemaining: Int = 25 * 60
    @Published var state: TimerState = .stopped

    private var timer: Timer?

    func start() {
        state = .running
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tick()
            }
        }
    }
}
```
