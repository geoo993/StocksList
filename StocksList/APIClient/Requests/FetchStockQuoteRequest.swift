import Foundation

/// `GET /quote?symbol=AAPL`
///
/// Fetches price of stock symbol
struct FetchStockQuoteRequest: HTTPRequest {
    typealias ResponseObject = APIClient.Price
    typealias ErrorObject = APIClient.Error
    
    var provider: APIClient.Provider { .finnhub }
    var path: String { "/api/v1/quote" }
    var headers: HTTPHeaders?
    var queryItems: [URLQueryItem]?
    
    init(symbol: String) {
        headers = ["X-Finnhub-Token": provider.apiToken]
        queryItems = [URLQueryItem(name: "symbol", value: symbol)]
    }
}
