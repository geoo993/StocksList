import Foundation
@testable import StocksList

final class MockFavouredStocksRepository: FavouredStocksRepository {
    private var items: [Stock] = []

    func register(stocks: [Stock]) {
        self.items = stocks
    }

    func savedStocks() throws -> [Stock] {
        items
    }

    func save(stock: Stock) throws {
        items.append(stock)
    }

    func delete(stock: Stock) throws {
        items = items.filter { $0.symbol != stock.symbol }
    }
}
