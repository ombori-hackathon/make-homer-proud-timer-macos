import SwiftUI

struct TimerControlsView: View {
    let state: TimerState
    let onStart: () -> Void
    let onPause: () -> Void
    let onReset: () -> Void

    var body: some View {
        HStack(spacing: 20) {
            // Reset button
            Button(action: onReset) {
                Image(systemName: "arrow.counterclockwise")
                    .font(.title2)
                    .frame(width: 44, height: 44)
            }
            .buttonStyle(.bordered)
            .disabled(!state.canReset)

            // Start/Pause button
            Button(action: {
                if state == .running {
                    onPause()
                } else {
                    onStart()
                }
            }) {
                Image(systemName: state == .running ? "pause.fill" : "play.fill")
                    .font(.title)
                    .frame(width: 60, height: 60)
            }
            .buttonStyle(.borderedProminent)

            // Placeholder for symmetry
            Color.clear
                .frame(width: 44, height: 44)
        }
    }
}
