import SwiftUI

struct GodListView: View {
    @StateObject private var service = GodSelectionService()
    let onGodSelected: (God) -> Void
    @Binding var navigationPath: NavigationPath

    private let columns = [
        GridItem(.adaptive(minimum: 140, maximum: 180), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            if service.isLoading {
                ProgressView("Loading gods...")
                    .padding(.top, 100)
            } else {
                VStack(alignment: .leading, spacing: 24) {
                    // Favorites section (only show if there are favorites)
                    if !service.favoriteGods.isEmpty {
                        godSection(title: "Favorites", gods: service.favoriteGods, icon: "star.fill")
                    }

                    // All gods section (or non-favorites if there are favorites)
                    if service.favoriteGods.isEmpty {
                        godSection(title: "All Gods", gods: service.gods, icon: "person.3.fill")
                    } else {
                        godSection(title: "Others", gods: service.nonFavoriteGods, icon: "person.3")
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Choose Your God")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                if let god = service.selectedGod {
                    Button("Select \(god.name)") {
                        onGodSelected(god)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .task {
            await service.loadData()
        }
    }

    @ViewBuilder
    private func godSection(title: String, gods: [God], icon: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            // Section header
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(.secondary)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            // Grid of god cards
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(gods) { god in
                    GodCardView(
                        god: god,
                        isFavorite: service.isFavorite(god),
                        isSelected: service.isSelected(god),
                        onSelect: {
                            navigationPath.append(GodNavigation.detail(god))
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
}
