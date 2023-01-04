import Foundation

protocol WatchlistInteractor {
    func savedStocks() throws -> [Stock]
    func save(stock: Stock) throws
    func delete(stock: Stock) throws
    func search(query: String) async throws -> [StockSearch]
    func refreshSearch(of stock: Stock) throws -> [StockSearch]
    func price(for stock: Stock) async throws -> Price
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

    func savedStocks() throws -> [Stock] {
        try favouredStocksRepository.savedStocks()
    }
    
    func save(stock: Stock) throws {
        try favouredStocksRepository.save(stock: stock)
    }
    
    func delete(stock: Stock) throws {
        try favouredStocksRepository.delete(stock: stock)
    }
    
    func search(query: String) async throws -> [StockSearch] {
        let stock = try await stocksRepository.fetchStock(with: query)
        return try refreshSearch(of: stock)
    }
    
    func refreshSearch(of stock: Stock) throws -> [StockSearch] {
        let saved = try savedStocks()
        let isSaved = saved.contains(where: { $0.symbol == stock.symbol })
        return [StockSearch(stock: stock, isSaved: isSaved)]
    }
    
    func price(for stock: Stock) async throws -> Price {
        try await stocksRepository.fetchStockQuote(with: stock.symbol)
    }
}
