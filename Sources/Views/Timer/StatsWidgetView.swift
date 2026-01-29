import SwiftUI

struct StatsWidgetView: View {
    let todayCount: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "flame.fill")
                .foregroundStyle(.orange)

            Text("\(todayCount)")
                .font(.headline)

            Text("today")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
        .background(.regularMaterial, in: Capsule())
    }
}
