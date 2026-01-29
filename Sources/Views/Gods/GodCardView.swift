import SwiftUI

struct GodCardView: View {
    let god: God
    let isFavorite: Bool
    let isSelected: Bool
    let onSelect: () -> Void
    let onToggleFavorite: () -> Void

    private var theme: GodTheme {
        GodTheme.forGod(named: god.name)
    }

    var body: some View {
        VStack(spacing: 12) {
            // Icon and favorite star
            ZStack(alignment: .topTrailing) {
                Image(systemName: god.icon)
                    .font(.system(size: 36))
                    .foregroundStyle(isSelected ? .white : theme.primaryColor)
                    .frame(width: 60, height: 60)

                // Favorite star button - use ZStack to capture taps before card gesture
                ZStack {
                    Circle()
                        .fill(HadesTheme.tartarusGray.opacity(0.01))
                        .frame(width: 32, height: 32)
                    Image(systemName: isFavorite ? "star.fill" : "star")
                        .font(.system(size: 16))
                        .foregroundStyle(isFavorite ? .yellow : HadesTheme.secondaryText)
                }
                .onTapGesture {
                    onToggleFavorite()
                }
                .offset(x: 8, y: -8)
            }

            // Name
            Text(god.name)
                .font(.headline)
                .foregroundStyle(isSelected ? .white : HadesTheme.primaryText)

            // Domain
            Text(god.domain)
                .font(.caption)
                .foregroundStyle(isSelected ? .white.opacity(0.8) : HadesTheme.secondaryText)
                .lineLimit(1)

            // Selection indicator
            if isSelected {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 12))
                    Text("Selected")
                        .font(.caption2)
                }
                .foregroundStyle(.white.opacity(0.9))
            }
        }
        .frame(width: 120, height: 140)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? theme.primaryColor : HadesTheme.tartarusGray)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? theme.primaryColor : HadesTheme.asphodelusGray, lineWidth: isSelected ? 2 : 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            onSelect()
        }
    }
}
