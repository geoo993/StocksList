import Foundation

protocol StocksRepository {
    func fetchStock(with symbol: String) async throws -> Stock
    func fetchStockQuote(with symbol: String) async throws -> Price
}

struct DefaultStocksRepository: StocksRepository {
    private let apiClient: APIClientRequestable
        
    init(apiClient: APIClientRequestable = APIClient()) {
        self.apiClient = apiClient
    }
    
    func fetchStock(with symbol: String) async throws -> Stock {
        let request = FetchStockRequest(symbol: symbol)
        let result = try await apiClient.execute(request: request)
        return Stock(model: result)
    }
    
    func fetchStockQuote(with symbol: String) async throws -> Price {
        let request = FetchStockQuoteRequest(symbol: symbol)
        let result = try await apiClient.execute(request: request)
        return Price(model: result)
    }
}
