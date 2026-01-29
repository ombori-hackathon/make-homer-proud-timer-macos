import SwiftUI

/// Minimalistic polygon-style god icons inspired by Hades aesthetic
/// Bold geometric shapes with clean lines
struct GodIconView: View {
    let godName: String
    let theme: GodTheme
    let size: CGFloat

    init(godName: String, size: CGFloat = 80) {
        self.godName = godName
        self.theme = GodTheme.forGod(named: godName)
        self.size = size
    }

    var body: some View {
        ZStack {
            // Background circle
            Circle()
                .fill(theme.primaryColor.opacity(0.15))
                .frame(width: size, height: size)

            // God-specific icon
            iconShape
                .frame(width: size * 0.6, height: size * 0.6)
        }
    }

    @ViewBuilder
    private var iconShape: some View {
        switch godName.lowercased() {
        case "athena":
            AthenaIcon(color: theme.primaryColor)
        case "zeus":
            ZeusIcon(color: theme.primaryColor)
        case "poseidon":
            PoseidonIcon(color: theme.primaryColor)
        case "ares":
            AresIcon(color: theme.primaryColor)
        case "artemis":
            ArtemisIcon(color: theme.primaryColor)
        case "apollo":
            ApolloIcon(color: theme.primaryColor)
        case "aphrodite":
            AphroditeIcon(color: theme.primaryColor)
        case "hephaestus":
            HephaestusIcon(color: theme.primaryColor)
        case "hermes":
            HermesIcon(color: theme.primaryColor)
        case "dionysus":
            DionysusIcon(color: theme.primaryColor)
        case "demeter":
            DemeterIcon(color: theme.primaryColor)
        case "hera":
            HeraIcon(color: theme.primaryColor)
        default:
            DefaultGodIcon(color: theme.primaryColor)
        }
    }
}

// MARK: - Individual God Icons (Minimalistic Polygon Style)

/// Athena - Owl/Wisdom (triangular owl face)
struct AthenaIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Owl face - triangle
                Path { path in
                    path.move(to: CGPoint(x: w * 0.5, y: 0))
                    path.addLine(to: CGPoint(x: w, y: h * 0.8))
                    path.addLine(to: CGPoint(x: 0, y: h * 0.8))
                    path.closeSubpath()
                }
                .fill(color)

                // Eyes - two circles
                HStack(spacing: w * 0.15) {
                    Circle()
                        .fill(Color.white)
                        .frame(width: w * 0.2, height: w * 0.2)
                    Circle()
                        .fill(Color.white)
                        .frame(width: w * 0.2, height: w * 0.2)
                }
                .offset(y: h * 0.15)

                // Beak - small triangle
                Path { path in
                    path.move(to: CGPoint(x: w * 0.5, y: h * 0.45))
                    path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.6))
                    path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.6))
                    path.closeSubpath()
                }
                .fill(color.opacity(0.7))
            }
        }
    }
}

/// Zeus - Lightning bolt
struct ZeusIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                path.move(to: CGPoint(x: w * 0.6, y: 0))
                path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.4))
                path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.4))
                path.addLine(to: CGPoint(x: w * 0.35, y: h))
                path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
                path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.5))
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

/// Poseidon - Trident
struct PoseidonIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Main shaft
                Rectangle()
                    .fill(color)
                    .frame(width: w * 0.1, height: h * 0.9)
                    .offset(y: h * 0.05)

                // Three prongs
                HStack(spacing: w * 0.15) {
                    // Left prong
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: h * 0.3))
                        path.addLine(to: CGPoint(x: w * 0.08, y: 0))
                        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.3))
                    }
                    .fill(color)
                    .frame(width: w * 0.16)

                    // Center prong (taller)
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: h * 0.25))
                        path.addLine(to: CGPoint(x: w * 0.1, y: 0))
                        path.addLine(to: CGPoint(x: w * 0.2, y: h * 0.25))
                    }
                    .fill(color)
                    .frame(width: w * 0.2)
                    .offset(y: -h * 0.05)

                    // Right prong
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: h * 0.3))
                        path.addLine(to: CGPoint(x: w * 0.08, y: 0))
                        path.addLine(to: CGPoint(x: w * 0.16, y: h * 0.3))
                    }
                    .fill(color)
                    .frame(width: w * 0.16)
                }
                .offset(y: -h * 0.35)
            }
        }
    }
}

/// Ares - Shield with X
struct AresIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Shield shape (rounded bottom)
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: w, y: 0))
                    path.addLine(to: CGPoint(x: w, y: h * 0.5))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.5, y: h),
                        control: CGPoint(x: w, y: h * 0.85)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: 0, y: h * 0.5),
                        control: CGPoint(x: 0, y: h * 0.85)
                    )
                    path.closeSubpath()
                }
                .fill(color)

                // X mark
                Path { path in
                    path.move(to: CGPoint(x: w * 0.3, y: h * 0.2))
                    path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.6))
                    path.move(to: CGPoint(x: w * 0.7, y: h * 0.2))
                    path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.6))
                }
                .stroke(Color.white, lineWidth: 3)
            }
        }
    }
}

/// Artemis - Crescent moon with arrow
struct ArtemisIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Crescent moon
                Path { path in
                    path.addArc(
                        center: CGPoint(x: w * 0.5, y: h * 0.5),
                        radius: w * 0.4,
                        startAngle: .degrees(-30),
                        endAngle: .degrees(210),
                        clockwise: false
                    )
                    path.addArc(
                        center: CGPoint(x: w * 0.35, y: h * 0.5),
                        radius: w * 0.3,
                        startAngle: .degrees(210),
                        endAngle: .degrees(-30),
                        clockwise: true
                    )
                }
                .fill(color)
            }
        }
    }
}

/// Apollo - Sun rays
struct ApolloIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let center = CGPoint(x: w / 2, y: h / 2)

            ZStack {
                // Center circle
                Circle()
                    .fill(color)
                    .frame(width: w * 0.4, height: h * 0.4)

                // Rays
                ForEach(0..<8, id: \.self) { i in
                    Path { path in
                        let angle = Double(i) * .pi / 4
                        let innerRadius = w * 0.25
                        let outerRadius = w * 0.45

                        let startX = center.x + innerRadius * cos(angle)
                        let startY = center.y + innerRadius * sin(angle)
                        let endX = center.x + outerRadius * cos(angle)
                        let endY = center.y + outerRadius * sin(angle)

                        path.move(to: CGPoint(x: startX, y: startY))
                        path.addLine(to: CGPoint(x: endX, y: endY))
                    }
                    .stroke(color, lineWidth: 3)
                }
            }
        }
    }
}

/// Aphrodite - Heart
struct AphroditeIcon: View {
    let color: Color

    var body: some View {
        Image(systemName: "heart.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(color)
    }
}

/// Hephaestus - Anvil/Hammer
struct HephaestusIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Anvil base
                Path { path in
                    path.move(to: CGPoint(x: w * 0.1, y: h * 0.9))
                    path.addLine(to: CGPoint(x: w * 0.9, y: h * 0.9))
                    path.addLine(to: CGPoint(x: w * 0.8, y: h * 0.6))
                    path.addLine(to: CGPoint(x: w * 0.2, y: h * 0.6))
                    path.closeSubpath()
                }
                .fill(color)

                // Hammer head
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: w * 0.5, height: h * 0.2)
                    .offset(y: -h * 0.2)

                // Hammer handle
                Rectangle()
                    .fill(color.opacity(0.8))
                    .frame(width: w * 0.08, height: h * 0.3)
                    .offset(y: h * 0.05)
            }
        }
    }
}

/// Hermes - Winged sandal
struct HermesIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Wing
                Path { path in
                    path.move(to: CGPoint(x: w * 0.2, y: h * 0.5))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.8, y: h * 0.2),
                        control: CGPoint(x: w * 0.5, y: h * 0.1)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.5, y: h * 0.5),
                        control: CGPoint(x: w * 0.7, y: h * 0.4)
                    )
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.2, y: h * 0.5),
                        control: CGPoint(x: w * 0.3, y: h * 0.45)
                    )
                }
                .fill(color)

                // Sandal base
                RoundedRectangle(cornerRadius: 4)
                    .fill(color)
                    .frame(width: w * 0.7, height: h * 0.15)
                    .offset(y: h * 0.3)
            }
        }
    }
}

/// Dionysus - Wine goblet
struct DionysusIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Cup
                Path { path in
                    path.move(to: CGPoint(x: w * 0.15, y: 0))
                    path.addLine(to: CGPoint(x: w * 0.85, y: 0))
                    path.addLine(to: CGPoint(x: w * 0.7, y: h * 0.5))
                    path.addLine(to: CGPoint(x: w * 0.3, y: h * 0.5))
                    path.closeSubpath()
                }
                .fill(color)

                // Stem
                Rectangle()
                    .fill(color)
                    .frame(width: w * 0.08, height: h * 0.25)
                    .offset(y: h * 0.25)

                // Base
                Ellipse()
                    .fill(color)
                    .frame(width: w * 0.4, height: h * 0.1)
                    .offset(y: h * 0.4)
            }
        }
    }
}

/// Demeter - Wheat stalk
struct DemeterIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            ZStack {
                // Stem
                Path { path in
                    path.move(to: CGPoint(x: w * 0.5, y: h))
                    path.addQuadCurve(
                        to: CGPoint(x: w * 0.5, y: h * 0.1),
                        control: CGPoint(x: w * 0.45, y: h * 0.5)
                    )
                }
                .stroke(color, lineWidth: 2)

                // Wheat grains (alternating sides)
                ForEach(0..<5, id: \.self) { i in
                    Ellipse()
                        .fill(color)
                        .frame(width: w * 0.15, height: h * 0.1)
                        .offset(
                            x: (i % 2 == 0 ? 1 : -1) * w * 0.12,
                            y: -h * 0.35 + CGFloat(i) * h * 0.1
                        )
                }
            }
        }
    }
}

/// Hera - Crown
struct HeraIcon: View {
    let color: Color

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height

            Path { path in
                // Crown base
                path.move(to: CGPoint(x: 0, y: h * 0.9))
                path.addLine(to: CGPoint(x: 0, y: h * 0.5))

                // Left peak
                path.addLine(to: CGPoint(x: w * 0.15, y: h * 0.3))
                path.addLine(to: CGPoint(x: w * 0.25, y: h * 0.5))

                // Center-left peak
                path.addLine(to: CGPoint(x: w * 0.35, y: h * 0.2))
                path.addLine(to: CGPoint(x: w * 0.45, y: h * 0.45))

                // Center peak (tallest)
                path.addLine(to: CGPoint(x: w * 0.5, y: 0))
                path.addLine(to: CGPoint(x: w * 0.55, y: h * 0.45))

                // Center-right peak
                path.addLine(to: CGPoint(x: w * 0.65, y: h * 0.2))
                path.addLine(to: CGPoint(x: w * 0.75, y: h * 0.5))

                // Right peak
                path.addLine(to: CGPoint(x: w * 0.85, y: h * 0.3))
                path.addLine(to: CGPoint(x: w, y: h * 0.5))

                path.addLine(to: CGPoint(x: w, y: h * 0.9))
                path.closeSubpath()
            }
            .fill(color)
        }
    }
}

/// Default god icon - Star
struct DefaultGodIcon: View {
    let color: Color

    var body: some View {
        Image(systemName: "star.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .foregroundStyle(color)
    }
}
