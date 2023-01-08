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
        async let result = try apiClient.execute(request: request)
        async let price = try quote(of: symbol)
        return try await Stock(stock: result, price: price)
    }
    
    func fetchStockQuote(with symbol: String) async throws -> Price {
        let result = try await quote(of: symbol)
        return Price(model: result)
    }
    
    private func quote(of symbol: String) async throws -> APIClient.Price {
        let request = FetchStockQuoteRequest(symbol: symbol)
        return try await apiClient.execute(request: request)
    }
}
