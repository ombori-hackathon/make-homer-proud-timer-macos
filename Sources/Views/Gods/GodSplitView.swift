import SwiftUI

/// Split-view god selection with list on left and detail on right
struct GodSplitView: View {
    let onGodSelected: (God) -> Void
    @StateObject private var service = GodSelectionService()
    @State private var selectedGod: God?

    var body: some View {
        HSplitView {
            // Left: God list sidebar
            GodListSidebar(
                service: service,
                selectedGod: $selectedGod
            )
            .frame(minWidth: 220, idealWidth: 260, maxWidth: 320)

            // Right: Detail pane
            if let god = selectedGod {
                GodDetailPane(
                    god: god,
                    service: service,
                    onSelect: onGodSelected
                )
            } else {
                // Empty state
                emptyState
            }
        }
        .background(HadesTheme.underworldBlack)
        .task {
            await service.loadData()
            // Auto-select first god or current selected
            if let selected = service.selectedGod {
                selectedGod = selected
            } else if let first = service.gods.first {
                selectedGod = first
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "person.3.fill")
                .font(.system(size: 48))
                .foregroundStyle(HadesTheme.tertiaryText)

            Text("Select a god")
                .font(.headline)
                .foregroundStyle(HadesTheme.secondaryText)

            Text("Choose from the list to see details")
                .font(.caption)
                .foregroundStyle(HadesTheme.tertiaryText)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(HadesTheme.underworldBlack)
    }
}
