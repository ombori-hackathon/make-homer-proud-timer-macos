import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppStateService

    var body: some View {
        MainNavigationView()
    }
}
