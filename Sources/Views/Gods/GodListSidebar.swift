import SwiftUI

/// Sidebar list of gods with elongated cards for split-view
struct GodListSidebar: View {
    @ObservedObject var service: GodSelectionService
    @Binding var selectedGod: God?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                if service.isLoading {
                    loadingView
                } else {
                    // Favorites section
                    if !service.favoriteGods.isEmpty {
                        sectionHeader("Favorites", icon: "star.fill", color: .yellow)
                        godsList(service.favoriteGods)
                    }

                    // All Gods section
                    sectionHeader(
                        service.favoriteGods.isEmpty ? "All Gods" : "Others",
                        icon: "person.3",
                        color: HadesTheme.secondaryText
                    )
                    godsList(service.favoriteGods.isEmpty ? service.gods : service.nonFavoriteGods)
                }
            }
            .padding(.vertical, 8)
        }
        .background(HadesTheme.sidebarBackground)
    }

    private var loadingView: some View {
        VStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Loading gods...")
                .font(.caption)
                .foregroundStyle(HadesTheme.secondaryText)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 40)
    }

    private func sectionHeader(_ title: String, icon: String, color: Color) -> some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
                .font(.caption)
                .foregroundStyle(color)
            Text(title)
                .font(.caption)
                .fontWeight(.semibold)
                .foregroundStyle(HadesTheme.secondaryText)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .padding(.top, 8)
    }

    private func godsList(_ gods: [God]) -> some View {
        VStack(spacing: 2) {
            ForEach(gods) { god in
                GodElongatedCard(
                    god: god,
                    isFavorite: service.isFavorite(god),
                    isSelected: selectedGod?.id == god.id,
                    onSelect: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            selectedGod = god
                        }
                    },
                    onToggleFavorite: {
                        Task {
                            await service.toggleFavorite(god)
                        }
                    }
                )
            }
        }
    }
}

/// Elongated card for god list sidebar
struct GodElongatedCard: View {
    let god: God
    let isFavorite: Bool
    let isSelected: Bool
    let onSelect: () -> Void
    let onToggleFavorite: () -> Void

    private var theme: GodTheme {
        GodTheme.forGod(named: god.name)
    }

    var body: some View {
        Button(action: onSelect) {
            HStack(spacing: 0) {
                // Colored accent bar
                RoundedRectangle(cornerRadius: 2)
                    .fill(theme.primaryColor)
                    .frame(width: 4)
                    .padding(.vertical, 8)

                HStack(spacing: 12) {
                    // God icon
                    Image(systemName: god.icon)
                        .font(.system(size: 18))
                        .foregroundStyle(isSelected ? theme.primaryColor : HadesTheme.primaryText)
                        .frame(width: 28)

                    // Name and domain
                    VStack(alignment: .leading, spacing: 2) {
                        Text(god.name)
                            .font(.subheadline)
                            .fontWeight(isSelected ? .semibold : .regular)
                            .foregroundStyle(HadesTheme.primaryText)

                        Text(god.domain)
                            .font(.caption2)
                            .foregroundStyle(HadesTheme.secondaryText)
                            .lineLimit(1)
                    }

                    Spacer()

                    // Favorite indicator
                    if isFavorite {
                        Image(systemName: "star.fill")
                            .font(.caption)
                            .foregroundStyle(.yellow)
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
            }
            .background(
                isSelected ? HadesTheme.sidebarSelected : Color.clear
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                onToggleFavorite()
            } label: {
                Label(
                    isFavorite ? "Remove from Favorites" : "Add to Favorites",
                    systemImage: isFavorite ? "star.slash" : "star"
                )
            }
        }
    }
}
