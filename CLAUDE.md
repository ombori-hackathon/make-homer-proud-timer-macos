# Pantheon Timer - SwiftUI App

macOS desktop app for the Pantheon Timer productivity tool. See `/specs/pantheon-timer-vision.md` for full product vision.

## Product Summary
Pomodoro/study timer where Greek gods oversee your sessions. Gods provide pep talks, celebrate breaks, and match different work types (Athena for deep work, Apollo for creative, Ares for physical, etc.).

## Commands
- Build: `swift build`
- Run: `swift run MakeHomerProudTimerClient` (opens GUI window)
- Test: `swift test`

## Architecture
- SwiftUI app with native macOS window
- Entry point: Sources/MakeHomerProudTimerApp.swift
- Main view: Sources/ContentView.swift
- Data models: Sources/Models.swift
- Uses async/await with URLSession
- Targets macOS 14+

## Key Components (Planned)
- **TimerView**: Main circular timer with start/pause/reset
- **GodSelectionView**: Grid of gods to choose from
- **God model**: name, domain, icon, focusMessages[], breakMessages[]
- **TimerService**: Timer logic using Timer.publish() or Task.sleep()
- **UserDefaults**: Settings and session stats persistence

## API Integration
- Backend runs at http://localhost:8000
- Health check: GET /health
- Sample data: GET /items (returns list of items)

## Adding Features
1. Create new SwiftUI views in Sources/
2. Add new async functions for API calls in views or a dedicated APIClient
2. Use `URLSession.shared.data(from:)` for GET requests
3. Use `URLSession.shared.data(for:)` for POST/PUT with URLRequest
