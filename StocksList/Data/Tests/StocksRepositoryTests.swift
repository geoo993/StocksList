import XCTest
@testable import StocksList

final class StocksRepositoryTests: XCTestCase {
    var apiClient: MockAPIClient!
    var sut: StocksRepository!
    
    override func setUp() {
        apiClient = MockAPIClient()
        sut = DefaultStocksRepository(apiClient: apiClient)
    }

    override func tearDown() {
        apiClient = nil
        sut = nil
        super.tearDown()
    }

    func testFetchStockFails() async {
        apiClient.executeRequest = { _ in
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let stock = try? await sut.fetchStock(with: "symbol")
        XCTAssertNil(stock)
    }
        
    func testFetchStockSucceeds() async throws {
        let symbol = "AAPL"
        apiClient.executeRequest = {
            if $0 is FetchStockRequest {
                return .success(FetchStockRequest.fixture())
            }
            if $0 is FetchStockQuoteRequest {
                return .success(FetchStockQuoteRequest.fixture())
            }
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let stock = try await sut.fetchStock(with: symbol)
        XCTAssertEqual(stock.name, "Apple Inc")
        XCTAssertEqual(stock.symbol, symbol)
        XCTAssertTrue(apiClient.executeCalled)
    }
    
    func testStockQuoteFails() async {
        apiClient.executeRequest = { _ in
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let quote = try? await sut.fetchStockQuote(with: "symbol")
        XCTAssertNil(quote)
        
    }
    
    func testStockQuoteSucceeds() async throws {
        apiClient.executeRequest = {
            if $0 is FetchStockQuoteRequest {
                return .success(FetchStockQuoteRequest.fixture())
            }
            return .failure(.unknown)
        }
        XCTAssertFalse(apiClient.executeCalled)
        let quote = try await sut.fetchStockQuote(with: "AAPL")
        XCTAssertEqual(quote.value, 88.73)
        XCTAssertEqual(quote.percentageChange, -0.2473)
        XCTAssertTrue(apiClient.executeCalled)
    }
}
