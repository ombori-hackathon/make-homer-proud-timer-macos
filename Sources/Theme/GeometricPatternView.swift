import SwiftUI

/// A subtle repeating geometric pattern background for each god
struct GeometricPatternView: View {
    let theme: GodTheme
    let patternSize: CGFloat
    let opacity: Double

    init(theme: GodTheme, patternSize: CGFloat = 40, opacity: Double = 0.04) {
        self.theme = theme
        self.patternSize = patternSize
        self.opacity = opacity
    }

    var body: some View {
        GeometryReader { geometry in
            let columns = Int(geometry.size.width / patternSize) + 2
            let rows = Int(geometry.size.height / patternSize) + 2

            Canvas { context, _ in
                for row in 0..<rows {
                    for col in 0..<columns {
                        let xOffset = (row % 2 == 0) ? 0 : patternSize / 2
                        let x = CGFloat(col) * patternSize + xOffset
                        let y = CGFloat(row) * patternSize

                        // Draw the pattern symbol
                        let symbol = context.resolveSymbol(id: "pattern")!
                        context.draw(symbol, at: CGPoint(x: x, y: y))
                    }
                }
            } symbols: {
                Image(systemName: theme.patternSymbol)
                    .font(.system(size: patternSize * 0.4))
                    .foregroundStyle(theme.primaryColor.opacity(opacity))
                    .tag("pattern")
            }
        }
        .ignoresSafeArea()
    }
}

/// Animated version with subtle floating motion
struct AnimatedGeometricPatternView: View {
    let theme: GodTheme
    @State private var offset: CGFloat = 0

    var body: some View {
        GeometricPatternView(theme: theme)
            .offset(y: offset)
            .onAppear {
                withAnimation(
                    .easeInOut(duration: 8)
                    .repeatForever(autoreverses: true)
                ) {
                    offset = 10
                }
            }
    }
}
