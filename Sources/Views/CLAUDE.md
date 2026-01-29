# SwiftUI Views

## Conventions
- One view per file
- Use `@StateObject` for view-owned observable objects
- Use `@ObservedObject` for passed-in observable objects
- Use `@State` for simple value types owned by view
- Use `@Binding` for two-way value passing

## File Naming
- `<Component>View.swift` for main views
- Group related views in same directory

## SF Symbols
- Use `Image(systemName: "symbol.name")`
- Prefer filled variants for selected states
- Common symbols:
  - Timer: `timer`, `clock.fill`
  - Play/Pause: `play.fill`, `pause.fill`
  - Reset: `arrow.counterclockwise`

## Layout Patterns
- Use `VStack`, `HStack`, `ZStack` for composition
- Apply `.padding()` at leaf views
- Use `Spacer()` for flexible spacing
