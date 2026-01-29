import SwiftUI
import AppKit

@main
struct MakeHomerProudTimerApp: App {
    @StateObject private var appState = AppStateService()

    init() {
        // Required for swift run to show GUI window
        NSApplication.shared.setActivationPolicy(.regular)
        NSApplication.shared.activate(ignoringOtherApps: true)
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
        .defaultSize(width: 900, height: 650)
    }
}
