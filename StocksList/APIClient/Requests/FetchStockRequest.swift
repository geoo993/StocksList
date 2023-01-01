import Foundation

/// `GET /stock/profile2?symbol=AAPL`
///
/// Fetches the company profile of stock
struct FetchStockRequest: HTTPRequest {
    typealias ResponseObject = APIClient.Stock
    typealias ErrorObject = APIClient.Error
    
    var provider: APIClient.Provider { .finnhub }
    var path: String { "/api/v1/stock/profile2" }
    var headers: HTTPHeaders?
    var queryItems: [URLQueryItem]?
    
    init(symbol: String) {
        headers = ["X-Finnhub-Token": provider.apiToken]
        queryItems = [URLQueryItem(name: "symbol", value: symbol)]
    }
}
