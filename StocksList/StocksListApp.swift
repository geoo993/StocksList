import SwiftUI

@main
struct StocksListApp: App {
    var body: some Scene {
        WindowGroup {
            WatchlistView(viewModel: .init())
        }
    }
}
