import SwiftUI

struct GodAvatarView: View {
    let god: God?
    var onTap: (() -> Void)?

    var body: some View {
        Button(action: { onTap?() }) {
            VStack(spacing: 8) {
                // God icon
                ZStack(alignment: .bottomTrailing) {
                    Image(systemName: god?.icon ?? "questionmark.circle")
                        .font(.system(size: 40))
                        .foregroundStyle(.primary)

                    // Tap indicator
                    Image(systemName: "chevron.down.circle.fill")
                        .font(.system(size: 14))
                        .foregroundStyle(.secondary)
                        .offset(x: 4, y: 4)
                }

                // God name and domain
                if let god = god {
                    Text(god.name)
                        .font(.headline)
                    Text(god.domain)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                } else {
                    Text("Loading...")
                        .font(.headline)
                }
            }
            .padding()
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
    }
}
