import XCTest
@testable import StocksList

final class FetchStockQuoteRequestTests: XCTestCase {
    var apiClient: APIClient!
    var session: MockHTTPSession!
        
    override func setUp() {
        super.setUp()
        session = MockHTTPSession()
        apiClient = APIClient(session: session)
    }

    override func tearDown() {
        session = nil
        apiClient = nil
        super.tearDown()
    }
    
    func testRequest() async throws {
        session.register(
            stub: MockHTTPSession.Stub(
                path: "/api/v1/quote",
                method: .get,
                statusCode: 201,
                data: FetchStockQuoteRequest.dummy()
            )
        )
        let request = FetchStockQuoteRequest(symbol: "AAPL")
        let price = try await apiClient.execute(request: request)
        XCTAssertEqual(price.value, 88.73)
        XCTAssertEqual(price.percentageChange,  -0.2473)
    }
}
