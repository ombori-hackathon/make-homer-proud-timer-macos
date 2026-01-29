import SwiftUI

/// Hades-inspired dark theme colors for the Underworld aesthetic
/// Based on the Supergiant Games Hades visual style
struct HadesTheme {
    // MARK: - Base Dark Colors

    /// Primary background - deep black with subtle blue undertone
    static let underworldBlack = Color(hex: "0A0A0F")

    /// Card/surface background - slightly lighter for depth
    static let tartarusGray = Color(hex: "151520")

    /// Subtle purple tint for accents and hover states
    static let stygianPurple = Color(hex: "1A1A2E")

    /// Borders, dividers, and subtle elements
    static let asphodelusGray = Color(hex: "2D2D3A")

    /// Elevated surfaces and selected states
    static let elysiumGray = Color(hex: "3A3A4A")

    // MARK: - Text Colors

    /// Primary text - high contrast for readability
    static let primaryText = Color(hex: "E8E8E8")

    /// Secondary text - labels, captions, less important
    static let secondaryText = Color(hex: "9D9D9D")

    /// Tertiary text - hints, placeholders
    static let tertiaryText = Color(hex: "6D6D7D")

    // MARK: - Sidebar Colors

    /// Sidebar background - slightly darker than main
    static let sidebarBackground = Color(hex: "0D0D12")

    /// Sidebar selected row background
    static let sidebarSelected = Color(hex: "1F1F2A")

    /// Sidebar hover state
    static let sidebarHover = Color(hex: "18181F")

    // MARK: - Semantic Colors

    /// Success/completion state
    static let successGreen = Color(hex: "4CAF50")

    /// Warning state
    static let warningOrange = Color(hex: "FF9800")

    /// Error/danger state
    static let errorRed = Color(hex: "F44336")

    // MARK: - Gradient Helpers

    /// Creates a subtle gradient from the base background with a god's accent color
    static func backgroundGradient(accent: Color) -> LinearGradient {
        LinearGradient(
            colors: [
                underworldBlack,
                underworldBlack.opacity(0.95),
                accent.opacity(0.05)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    /// Creates a card background with subtle god accent
    static func cardBackground(accent: Color) -> Color {
        tartarusGray
    }

    /// Creates an accent border color
    static func accentBorder(accent: Color) -> Color {
        accent.opacity(0.2)
    }
}

// MARK: - View Extensions

extension View {
    /// Apply standard Hades dark background
    func hadesBackground() -> some View {
        self.background(HadesTheme.underworldBlack.ignoresSafeArea())
    }

    /// Apply card styling with optional accent color
    func hadesCard(accent: Color? = nil) -> some View {
        self
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(HadesTheme.tartarusGray)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(
                        accent.map { HadesTheme.accentBorder(accent: $0) } ?? HadesTheme.asphodelusGray.opacity(0.5),
                        lineWidth: 1
                    )
            )
    }
}
