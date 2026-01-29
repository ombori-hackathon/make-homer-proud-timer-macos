import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let timeString: String
    let sessionType: SessionType

    private var ringColor: Color {
        switch sessionType {
        case .focus:
            return .blue
        case .shortBreak:
            return .green
        case .longBreak:
            return .purple
        }
    }

    var body: some View {
        ZStack {
            // Background ring
            Circle()
                .stroke(ringColor.opacity(0.2), lineWidth: 20)

            // Progress ring
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    ringColor,
                    style: StrokeStyle(lineWidth: 20, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1), value: progress)

            // Time display
            VStack(spacing: 8) {
                Text(timeString)
                    .font(.system(size: 48, weight: .bold, design: .monospaced))

                Text(sessionType.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 250, height: 250)
    }
}
