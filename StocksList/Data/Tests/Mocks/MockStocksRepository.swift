import Foundation
@testable import StocksList

final class MockStocksRepository: StocksRepository {
    private var stock: Result<Stock, Error> = .success(.fixture())
    private var quote: Result<Price, Error> = .success(.fixture())

    func register(stock: Result<Stock, Error>) {
        self.stock = stock
    }

    func register(quote: Result<Price, Error>) {
        self.quote = quote
    }

    func fetchStock(with symbol: String) async throws -> Stock {
        switch stock {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }

    func fetchStockQuote(with symbol: String) async throws -> Price {
        switch quote {
        case .success(let value):
            return value
        case .failure(let error):
            throw error
        }
    }
}
