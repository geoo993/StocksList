import XCTest
@testable import StocksList

final class FetchStockRequestTests: XCTestCase {
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
                path: "/api/v1/stock/profile2",
                method: .get,
                statusCode: 201,
                data: FetchStockRequest.dummy()
            )
        )
        let request = FetchStockRequest(symbol: "AAPL")
        let price = try await apiClient.execute(request: request)
        XCTAssertEqual(price.name, "Apple Inc")
        XCTAssertEqual(price.symbol,  "AAPL")
        XCTAssertEqual(price.industry,  "Technology")
    }
}
