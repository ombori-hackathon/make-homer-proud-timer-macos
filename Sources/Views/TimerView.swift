import SwiftUI

struct TimerView: View {
    @StateObject private var timerService = TimerService()

    var body: some View {
        VStack(spacing: 24) {
            // Top bar with god and stats
            HStack {
                GodAvatarView(god: timerService.currentGod)

                Spacer()

                StatsWidgetView(todayCount: timerService.todaySessionCount)
            }
            .padding(.horizontal)

            Spacer()

            // Session type selector
            SessionTypeIndicator(
                sessionType: timerService.sessionType,
                isDisabled: timerService.state != .stopped,
                onSelect: { type in
                    timerService.setSessionType(type)
                }
            )

            // Timer display
            CircularProgressView(
                progress: timerService.progress,
                timeString: timerService.timeString,
                sessionType: timerService.sessionType
            )

            // God's message
            Text(timerService.currentMessage)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .frame(maxWidth: 300)
                .padding(.horizontal)

            // Controls
            TimerControlsView(
                state: timerService.state,
                onStart: { timerService.start() },
                onPause: { timerService.pause() },
                onReset: { timerService.reset() }
            )

            Spacer()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 500)
        .task {
            await timerService.loadRandomGod()
            await timerService.loadTodaySessions()
        }
    }
}
