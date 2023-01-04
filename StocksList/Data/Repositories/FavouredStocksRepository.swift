import CoreData

protocol FavouredStocksRepository {
    func savedStocks() throws -> [Stock]
    func save(stock: Stock) throws
    func delete(stock: Stock) throws 
}

struct DefaultFavouredStocksRepository: FavouredStocksRepository {
    private let context: CoreDataContextProviding
    
    init(context: CoreDataContextProviding = .live) {
        self.context = context
    }

    func savedStocks() throws -> [Stock] {
        try context.items()
    }
    
    func save(stock: Stock) throws {
        guard try !context.isSaved(stock) else { return }
        try context.save(stock)
    }
    
    func delete(stock: Stock) throws {
        guard try context.isSaved(stock) else { return }
        try context.delete(stock)
    }
}
