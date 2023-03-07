import SwiftUI

@main
struct StocksListApp: App {
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            WatchlistView(viewModel: .init())
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                }
        }
    }
}
