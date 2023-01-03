import Foundation

protocol WatchlistInteractor {
    func refreshStocks() -> [Stock]
    func loadStocks() -> [Stock]
    func search(query: String) async throws -> [Stock]
}

struct DefaultWatchlistInteractor: WatchlistInteractor {
    private let stocksRepository: StocksRepository
    private let favouredStocksRepository: FavouredStocksRepository
    
    init(
        stocksRepository: StocksRepository = DefaultStocksRepository(),
        favouredStocksRepository: FavouredStocksRepository = DefaultFavouredStocksRepository()
    ) {
        self.stocksRepository = stocksRepository
        self.favouredStocksRepository = favouredStocksRepository
    }
    
    func refreshStocks() -> [Stock] {
        []
    }
    
    func loadStocks() -> [Stock] {
        []
    }
    
    func search(query: String) async throws -> [Stock] {
        []
    }
}
