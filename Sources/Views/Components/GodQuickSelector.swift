import SwiftUI

/// Quick selector popover for changing gods from the timer screen
/// Shows current god info, favorites, and navigation to full list
struct GodQuickSelector: View {
    let currentGod: God?
    let theme: GodTheme
    let onGodSelected: (God) -> Void
    let onViewAllTapped: () -> Void

    @StateObject private var service = GodSelectionService()
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Current god header
            if let god = currentGod {
                currentGodHeader(god: god)
            }

            Divider()
                .background(HadesTheme.asphodelusGray)

            // Favorites section
            if !service.favoriteGods.isEmpty {
                favoritesSection
            } else {
                noFavoritesView
            }

            Divider()
                .background(HadesTheme.asphodelusGray)

            // View all button
            viewAllButton
        }
        .frame(width: 280)
        .background(HadesTheme.tartarusGray)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(theme.primaryColor.opacity(0.3), lineWidth: 1)
        )
        .task {
            await service.loadData()
        }
    }

    private func currentGodHeader(god: God) -> some View {
        HStack(spacing: 12) {
            // God icon
            Image(systemName: god.icon)
                .font(.system(size: 24))
                .foregroundStyle(theme.primaryColor)
                .frame(width: 40, height: 40)
                .background(
                    Circle()
                        .fill(theme.primaryColor.opacity(0.15))
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("Current God")
                    .font(.caption)
                    .foregroundStyle(HadesTheme.secondaryText)

                Text(god.name)
                    .font(.headline)
                    .foregroundStyle(HadesTheme.primaryText)

                Text(god.domain)
                    .font(.caption)
                    .foregroundStyle(theme.primaryColor)
            }

            Spacer()
        }
        .padding()
    }

    private var favoritesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                Text("Favorites")
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundStyle(HadesTheme.secondaryText)
            }
            .padding(.horizontal)
            .padding(.top, 12)

            ForEach(service.favoriteGods.prefix(5)) { god in
                favoriteGodRow(god: god)
            }
            .padding(.bottom, 8)
        }
    }

    private func favoriteGodRow(god: God) -> some View {
        Button {
            onGodSelected(god)
            dismiss()
        } label: {
            HStack(spacing: 10) {
                // Accent bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(GodTheme.forGod(named: god.name).primaryColor)
                    .frame(width: 4, height: 32)

                // Icon
                Image(systemName: god.icon)
                    .font(.system(size: 16))
                    .foregroundStyle(GodTheme.forGod(named: god.name).primaryColor)
                    .frame(width: 24)

                // Name
                Text(god.name)
                    .font(.subheadline)
                    .foregroundStyle(HadesTheme.primaryText)

                Spacer()

                // Checkmark if current
                if god.id == currentGod?.id {
                    Image(systemName: "checkmark")
                        .font(.caption)
                        .foregroundStyle(theme.primaryColor)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 6)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            god.id == currentGod?.id
                ? HadesTheme.sidebarSelected
                : Color.clear
        )
    }

    private var noFavoritesView: some View {
        VStack(spacing: 8) {
            Image(systemName: "star")
                .font(.title2)
                .foregroundStyle(HadesTheme.tertiaryText)

            Text("No favorites yet")
                .font(.caption)
                .foregroundStyle(HadesTheme.secondaryText)

            Text("Star gods to add them here")
                .font(.caption2)
                .foregroundStyle(HadesTheme.tertiaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
    }

    private var viewAllButton: some View {
        Button {
            onViewAllTapped()
            dismiss()
        } label: {
            HStack {
                Image(systemName: "person.3.fill")
                    .font(.subheadline)
                Text("View All Gods")
                    .font(.subheadline)
                    .fontWeight(.medium)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.caption)
            }
            .foregroundStyle(HadesTheme.primaryText)
            .padding()
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(Color.clear)
    }
}

/// Button that displays current god and triggers the quick selector
struct GodQuickSelectorButton: View {
    let god: God?
    let theme: GodTheme
    let onGodSelected: (God) -> Void
    let onViewAllTapped: () -> Void

    @State private var showingPopover = false

    var body: some View {
        Button {
            showingPopover = true
        } label: {
            HStack(spacing: 12) {
                // God icon
                if let god = god {
                    GodIconView(godName: god.name, size: 50)
                } else {
                    GodIconView(godName: "default", size: 50)
                }

                // Name and domain
                VStack(alignment: .leading, spacing: 2) {
                    Text(god?.name ?? "Select a God")
                        .font(.headline)
                        .foregroundStyle(HadesTheme.primaryText)

                    if let domain = god?.domain {
                        Text(domain)
                            .font(.caption)
                            .foregroundStyle(theme.primaryColor)
                    }
                }

                // Chevron indicator
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundStyle(HadesTheme.secondaryText)
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .popover(isPresented: $showingPopover, arrowEdge: .bottom) {
            GodQuickSelector(
                currentGod: god,
                theme: theme,
                onGodSelected: onGodSelected,
                onViewAllTapped: onViewAllTapped
            )
        }
    }
}
