import SwiftUI

@main
struct StocksListApp: App {
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
//            AuthenticationView(viewModel: .init())
            WatchlistView(viewModel: .init())
                .onChange(of: scenePhase) { _ in
                    persistenceController.save()
                }
        }
    }
}
