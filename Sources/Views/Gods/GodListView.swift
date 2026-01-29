import SwiftUI

/// God list view - now uses split view layout
struct GodListView: View {
    let onGodSelected: (God) -> Void
    @Binding var navigationPath: NavigationPath

    var body: some View {
        GodSplitView(onGodSelected: { god in
            onGodSelected(god)
            // Pop back to timer when god is selected
            navigationPath = NavigationPath()
        })
        .navigationTitle("Choose Your God")
        .background(HadesTheme.underworldBlack)
    }
}
