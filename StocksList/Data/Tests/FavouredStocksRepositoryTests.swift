import XCTest
@testable import StocksList

final class FavouredStocksRepositoryTests: XCTestCase {
    func testSaveAndDeletedStocks() throws {
        let sut = DefaultFavouredStocksRepository(context: .mock())
        let apple: Stock = .fixture()
        let tesla: Stock = .fixture(name: "Tesla", symbol: "TSLA")
        try sut.save(stock: apple)
        try sut.save(stock: tesla)
        let saved = try sut.savedStocks()
        XCTAssertEqual(saved, [apple, tesla])
        
        //
        try sut.delete(stock: apple)
        let saved2 = try sut.savedStocks()
        XCTAssertEqual(saved2, [tesla])
        
        //
        try sut.delete(stock: tesla)
        let saved3 = try sut.savedStocks()
        XCTAssertTrue(saved3.isEmpty)
    }
}

extension CoreDataContextProviding {
    fileprivate static func mock() -> Self {
        var values = [Stock]()
        return .init {
            values
        } isSaved: { stock in
            values.contains(where: { $0.symbol == stock.symbol })
        } save: { stock in
            values.append(stock)
        } delete: { stock in
            if let index = values.firstIndex(of: stock) {
                values.remove(at: index)
            }
        }
    }
}
