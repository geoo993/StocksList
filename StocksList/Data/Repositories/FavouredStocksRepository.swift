import Foundation

protocol FavouredStocksRepository {
    func savedStocks() async throws -> [Stock]
    func save(stock: Stock) throws
    func delete(stock: Stock) throws 
}

struct DefaultFavouredStocksRepository: FavouredStocksRepository {
    
    func savedStocks() async throws -> [Stock] {
        []
    }
    
    func save(stock: Stock) throws {
        
    }
    
    func delete(stock: Stock) throws {
        
    }
}
