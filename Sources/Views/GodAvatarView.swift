import SwiftUI

struct GodAvatarView: View {
    let god: God?

    var body: some View {
        VStack(spacing: 8) {
            // God icon
            Image(systemName: god?.icon ?? "questionmark.circle")
                .font(.system(size: 40))
                .foregroundStyle(.primary)

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
}
