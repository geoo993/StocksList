import XCTest
@testable import StocksList

final class WatchlistInteractorTests: XCTestCase {
    var apiClient: MockAPIClient!
    var stocksRepository: MockStocksRepository!
    var favouredStocksRepository: MockFavouredStocksRepository!
    var sut: DefaultWatchlistInteractor!
    
    override func setUp() {
        stocksRepository = MockStocksRepository()
        favouredStocksRepository = MockFavouredStocksRepository()
        sut = DefaultWatchlistInteractor(
            stocksRepository: stocksRepository,
            favouredStocksRepository: favouredStocksRepository
        )
    }

    override func tearDown() {
        apiClient = nil
        stocksRepository = nil
        favouredStocksRepository = nil
        sut = nil
        super.tearDown()
    }
    
    func testSavedStocks() throws {
        let stocks: [Stock] = [.fixture(), .fixture(name: "Tesla", symbol: "TSLA")]
        favouredStocksRepository.register(stocks: stocks)
        let results = try favouredStocksRepository.savedStocks()
        XCTAssertEqual(stocks, results)
    }
    
    func testSaveStock() throws {
        let stocks: [Stock] = [.fixture(), .fixture(name: "Tesla", symbol: "TSLA")]
        favouredStocksRepository.register(stocks: stocks)
        let saved = try favouredStocksRepository.savedStocks()
        XCTAssertEqual(saved.count, 2)
        try favouredStocksRepository.save(stock: .fixture(name: "Google", symbol: "GOOG"))
        let saved2 = try favouredStocksRepository.savedStocks()
        XCTAssertEqual(saved2.count, 3)
    }
    
    func testDeleteStock() throws {
        let stocks: [Stock] = [.fixture(), .fixture(name: "Tesla", symbol: "TSLA")]
        favouredStocksRepository.register(stocks: stocks)
        let saved = try favouredStocksRepository.savedStocks()
        XCTAssertEqual(saved.count, 2)
        try favouredStocksRepository.delete(stock: .fixture())
        let saved2 = try favouredStocksRepository.savedStocks()
        XCTAssertEqual(saved2.count, 1)
    }
    
    func testSearchFails() async {
        stocksRepository.register(stock: .failure(APIClient.Error.unknown))
        let results = try? await sut.search(query: "AAPL")
        XCTAssertNil(results)
    }
    
    func testSearchSucceeds() async throws {
        stocksRepository.register(stock: .success(.fixture()))
        let results = try await sut.search(query: "AAPL")
        XCTAssertEqual(results.count, 1)
        let result = try XCTUnwrap(results.first)
        XCTAssertEqual(result.stock.symbol, "AAPL")
        XCTAssertFalse(result.isSaved)
    }
    
    func testRefreshSearch() throws {
        let apple: Stock = .fixture()
        let tesla: Stock = .fixture(name: "Tesla", symbol: "TSLA")
        let stocks: [Stock] = [apple, tesla]
        favouredStocksRepository.register(stocks: stocks)
        let results = try sut.refreshSearch(of: apple)
        XCTAssertEqual(results, [StockSearch(stock: apple, isSaved: true)])
    }
    
    func testPriceFails() async {
        let apple: Stock = .fixture()
        stocksRepository.register(quote: .failure(APIClient.Error.unknown))
        let result = try? await sut.price(for: apple)
        XCTAssertNil(result)
    }
    
    func testPriceSucceeds() async throws {
        let apple: Stock = .fixture()
        let price: Price = .fixture()
        stocksRepository.register(quote: .success(.fixture()))
        let result = try await sut.price(for: apple)
        XCTAssertEqual(result, price)
    }
}
