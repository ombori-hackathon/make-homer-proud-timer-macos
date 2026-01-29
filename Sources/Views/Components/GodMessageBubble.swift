import SwiftUI

/// Comic-style chat bubble for god messages
struct GodMessageBubble: View {
    let message: String
    let godName: String
    let theme: GodTheme
    @State private var isVisible = false
    @State private var showTail = false

    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            // Speech bubble
            VStack(alignment: .leading, spacing: 4) {
                // God name label
                Text(godName)
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundStyle(theme.primaryColor)

                // Message text
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(HadesTheme.primaryText)
                    .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                BubbleShape(tailPosition: .bottomLeft)
                    .fill(HadesTheme.tartarusGray)
                    .shadow(color: theme.primaryColor.opacity(0.2), radius: 8, x: 0, y: 4)
            )
            .overlay(
                BubbleShape(tailPosition: .bottomLeft)
                    .stroke(theme.primaryColor.opacity(0.4), lineWidth: 2)
            )
            .scaleEffect(isVisible ? 1 : 0.8)
            .opacity(isVisible ? 1 : 0)

            Spacer()
        }
        .frame(maxWidth: 320)
        .onAppear {
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                isVisible = true
            }
        }
        .onChange(of: message) { _, _ in
            // Animate message change
            withAnimation(.easeOut(duration: 0.15)) {
                isVisible = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    isVisible = true
                }
            }
        }
    }
}

/// Custom bubble shape with comic-style tail
struct BubbleShape: Shape {
    enum TailPosition {
        case bottomLeft
        case bottomRight
    }

    let tailPosition: TailPosition
    let cornerRadius: CGFloat = 16
    let tailWidth: CGFloat = 12
    let tailHeight: CGFloat = 10

    func path(in rect: CGRect) -> Path {
        var path = Path()

        let tailX: CGFloat
        switch tailPosition {
        case .bottomLeft:
            tailX = 24
        case .bottomRight:
            tailX = rect.width - 24 - tailWidth
        }

        // Start from top-left, going clockwise
        path.move(to: CGPoint(x: cornerRadius, y: 0))

        // Top edge
        path.addLine(to: CGPoint(x: rect.width - cornerRadius, y: 0))

        // Top-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )

        // Right edge
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius - tailHeight))

        // Bottom-right corner
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: rect.height - tailHeight),
            control: CGPoint(x: rect.width, y: rect.height - tailHeight)
        )

        // Bottom edge to tail
        path.addLine(to: CGPoint(x: tailX + tailWidth, y: rect.height - tailHeight))

        // Tail
        path.addLine(to: CGPoint(x: tailX + tailWidth / 2, y: rect.height))
        path.addLine(to: CGPoint(x: tailX, y: rect.height - tailHeight))

        // Rest of bottom edge
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height - tailHeight))

        // Bottom-left corner
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - cornerRadius - tailHeight),
            control: CGPoint(x: 0, y: rect.height - tailHeight)
        )

        // Left edge
        path.addLine(to: CGPoint(x: 0, y: cornerRadius))

        // Top-left corner
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )

        return path
    }
}

/// Animated message bubble that periodically changes messages
struct AnimatedGodMessageBubble: View {
    let messages: [String]
    let godName: String
    let theme: GodTheme
    let changeInterval: TimeInterval

    @State private var currentIndex = 0
    @State private var timer: Timer?

    init(messages: [String], godName: String, theme: GodTheme, changeInterval: TimeInterval = 45) {
        self.messages = messages
        self.godName = godName
        self.theme = theme
        self.changeInterval = changeInterval
    }

    var body: some View {
        GodMessageBubble(
            message: messages.isEmpty ? "" : messages[currentIndex % messages.count],
            godName: godName,
            theme: theme
        )
        .onAppear {
            startTimer()
        }
        .onDisappear {
            timer?.invalidate()
        }
    }

    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: changeInterval, repeats: true) { [self] _ in
            Task { @MainActor in
                withAnimation {
                    currentIndex = (currentIndex + 1) % max(messages.count, 1)
                }
            }
        }
    }
}
