import SwiftUI

/// Color palette for each god, inspired by Hades game aesthetics
/// Bold, vibrant colors with geometric/polygon minimalist style
struct GodTheme {
    let name: String
    let primaryColor: Color      // Main accent color
    let secondaryColor: Color    // Complementary color
    let backgroundColor: Color   // Light background tint (legacy)
    let textColor: Color         // Text on background (legacy)
    let patternSymbol: String    // SF Symbol for geometric pattern

    // MARK: - Dark Mode Colors (Hades-inspired)

    /// Dark background with subtle god-colored tint
    var darkBackgroundColor: Color {
        HadesTheme.underworldBlack
    }

    /// Card/surface background for dark mode
    var darkCardColor: Color {
        HadesTheme.tartarusGray
    }

    /// Primary text color for dark mode
    var darkTextColor: Color {
        HadesTheme.primaryText
    }

    /// Secondary text color for dark mode
    var darkSecondaryTextColor: Color {
        HadesTheme.secondaryText
    }

    /// Background gradient with god accent for dark mode
    var darkBackgroundGradient: LinearGradient {
        HadesTheme.backgroundGradient(accent: primaryColor)
    }

    /// Card border color in dark mode
    var darkBorderColor: Color {
        primaryColor.opacity(0.2)
    }

    // MARK: - God Themes (Hades-inspired palettes)

    static let athena = GodTheme(
        name: "Athena",
        primaryColor: Color(hex: "D4AF37"),      // Golden yellow
        secondaryColor: Color(hex: "8B7355"),    // Bronze
        backgroundColor: Color(hex: "FFF8E7"),   // Warm cream
        textColor: Color(hex: "2C2416"),         // Dark brown
        patternSymbol: "triangle.fill"           // Triangles for wisdom/strategy
    )

    static let zeus = GodTheme(
        name: "Zeus",
        primaryColor: Color(hex: "5B4FCF"),      // Royal purple
        secondaryColor: Color(hex: "FFD700"),    // Lightning gold
        backgroundColor: Color(hex: "F0EEFF"),   // Soft lavender
        textColor: Color(hex: "1A1633"),         // Deep purple-black
        patternSymbol: "bolt.fill"               // Lightning bolts
    )

    static let poseidon = GodTheme(
        name: "Poseidon",
        primaryColor: Color(hex: "0077B6"),      // Deep ocean blue
        secondaryColor: Color(hex: "48CAE4"),    // Cyan wave
        backgroundColor: Color(hex: "E8F4F8"),   // Seafoam mist
        textColor: Color(hex: "023E58"),         // Dark navy
        patternSymbol: "water.waves"             // Waves
    )

    static let ares = GodTheme(
        name: "Ares",
        primaryColor: Color(hex: "C41E3A"),      // Blood red
        secondaryColor: Color(hex: "8B0000"),    // Dark crimson
        backgroundColor: Color(hex: "FFF0F0"),   // Soft blush
        textColor: Color(hex: "2D0A0A"),         // Deep burgundy
        patternSymbol: "shield.fill"             // Shields
    )

    static let artemis = GodTheme(
        name: "Artemis",
        primaryColor: Color(hex: "228B22"),      // Forest green
        secondaryColor: Color(hex: "90EE90"),    // Light green
        backgroundColor: Color(hex: "F0FFF0"),   // Honeydew
        textColor: Color(hex: "0D3D0D"),         // Dark forest
        patternSymbol: "moon.fill"               // Crescent moons
    )

    static let apollo = GodTheme(
        name: "Apollo",
        primaryColor: Color(hex: "FF8C00"),      // Bright orange/sun
        secondaryColor: Color(hex: "FFD700"),    // Gold
        backgroundColor: Color(hex: "FFFAF0"),   // Floral white
        textColor: Color(hex: "3D2800"),         // Dark amber
        patternSymbol: "sun.max.fill"            // Suns
    )

    static let aphrodite = GodTheme(
        name: "Aphrodite",
        primaryColor: Color(hex: "FF69B4"),      // Hot pink
        secondaryColor: Color(hex: "FFB6C1"),    // Light pink
        backgroundColor: Color(hex: "FFF0F5"),   // Lavender blush
        textColor: Color(hex: "4A0D2E"),         // Dark magenta
        patternSymbol: "heart.fill"              // Hearts
    )

    static let hephaestus = GodTheme(
        name: "Hephaestus",
        primaryColor: Color(hex: "B87333"),      // Copper
        secondaryColor: Color(hex: "FF6B35"),    // Forge orange
        backgroundColor: Color(hex: "FFF5EE"),   // Seashell
        textColor: Color(hex: "3D2314"),         // Dark brown
        patternSymbol: "hammer.fill"             // Hammers
    )

    static let hermes = GodTheme(
        name: "Hermes",
        primaryColor: Color(hex: "00CED1"),      // Teal/cyan
        secondaryColor: Color(hex: "20B2AA"),    // Light sea green
        backgroundColor: Color(hex: "F0FFFF"),   // Azure
        textColor: Color(hex: "0D3D3D"),         // Dark teal
        patternSymbol: "wind"                    // Wind/speed
    )

    static let dionysus = GodTheme(
        name: "Dionysus",
        primaryColor: Color(hex: "8B008B"),      // Dark magenta/wine
        secondaryColor: Color(hex: "DA70D6"),    // Orchid
        backgroundColor: Color(hex: "F8F0FF"),   // Ghost white purple
        textColor: Color(hex: "2D0D2D"),         // Deep purple
        patternSymbol: "drop.fill"               // Wine drops
    )

    static let demeter = GodTheme(
        name: "Demeter",
        primaryColor: Color(hex: "DAA520"),      // Goldenrod/wheat
        secondaryColor: Color(hex: "8FBC8F"),    // Dark sea green
        backgroundColor: Color(hex: "FFFEF0"),   // Ivory
        textColor: Color(hex: "3D3D0D"),         // Dark olive
        patternSymbol: "leaf.fill"               // Leaves
    )

    static let hera = GodTheme(
        name: "Hera",
        primaryColor: Color(hex: "4169E1"),      // Royal blue
        secondaryColor: Color(hex: "E6E6FA"),    // Lavender
        backgroundColor: Color(hex: "F0F0FF"),   // Ghost white
        textColor: Color(hex: "1A1A4D"),         // Dark blue
        patternSymbol: "crown.fill"              // Crowns
    )

    // Default/fallback theme
    static let `default` = GodTheme(
        name: "Olympus",
        primaryColor: Color(hex: "6366F1"),      // Indigo
        secondaryColor: Color(hex: "A5B4FC"),    // Light indigo
        backgroundColor: Color(hex: "F5F5FF"),   // Soft white
        textColor: Color(hex: "1E1B4B"),         // Dark indigo
        patternSymbol: "star.fill"               // Stars
    )

    /// Get theme for a god by name
    static func forGod(named name: String) -> GodTheme {
        switch name.lowercased() {
        case "athena": return .athena
        case "zeus": return .zeus
        case "poseidon": return .poseidon
        case "ares": return .ares
        case "artemis": return .artemis
        case "apollo": return .apollo
        case "aphrodite": return .aphrodite
        case "hephaestus": return .hephaestus
        case "hermes": return .hermes
        case "dionysus": return .dionysus
        case "demeter": return .demeter
        case "hera": return .hera
        default: return .default
        }
    }
}

// MARK: - Color Extension for Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
