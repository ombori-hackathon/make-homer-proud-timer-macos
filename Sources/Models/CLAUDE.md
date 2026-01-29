# Swift Models

## Conventions
- Models are `struct` with `Codable` and `Identifiable`
- Use `CodingKeys` enum for snake_case API mapping
- Keep models simple - no business logic

## API Response Models
```swift
struct God: Codable, Identifiable {
    let id: Int
    let name: String
    let domain: String
    let icon: String
    let coachingStyle: String
    let focusMessages: [String]
    let breakMessages: [String]
    let sessionStartMessages: [String]

    enum CodingKeys: String, CodingKey {
        case id, name, domain, icon
        case coachingStyle = "coaching_style"
        case focusMessages = "focus_messages"
        case breakMessages = "break_messages"
        case sessionStartMessages = "session_start_messages"
    }
}
```

## Enums
- Use `String` raw values for API compatibility
- Conform to `Codable` for JSON serialization
