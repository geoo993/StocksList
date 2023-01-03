import SwiftUI

final class ViewModel: ObservableObject {
    @Published var stocks = [Stock]()
    
    private let interactor: WatchlistInteractor
    
    init(interactor: WatchlistInteractor = DefaultWatchlistInteractor()) {
        self.interactor = interactor
    }
}
