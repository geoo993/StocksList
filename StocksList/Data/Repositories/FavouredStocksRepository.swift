import CoreData

protocol FavouredStocksRepository {
    func savedStocks() throws -> [Stock]
    func save(stock: Stock) throws
    func delete(stock: Stock) throws 
}

struct DefaultFavouredStocksRepository: FavouredStocksRepository {
    private let viewContext: NSManagedObjectContext
    
    init(
        viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext
    ) {
        self.viewContext = viewContext
    }

    func savedStocks() throws -> [Stock] {
        let request = StockItem.fetchRequest()
        let results = try viewContext.fetch(request)
        return results.compactMap { Stock(model: $0) }
    }
    
    func save(stock: Stock) throws {
        let request = StockItem.fetchRequest()
        let items = try viewContext.fetch(request)
        if items.contains(where: { $0.symbol == stock.symbol }) { return }
        let item = StockItem(context: viewContext)
        item.name = stock.name
        item.symbol = stock.symbol
        item.logo = stock.logo?.absoluteString
        try viewContext.save()
    }
    
    func delete(stock: Stock) throws {
        let request = StockItem.fetchRequest()
        let items = try viewContext.fetch(request)
        guard let item = items.first(where: { $0.symbol == stock.symbol }) else { return }
        viewContext.delete(item)
        try viewContext.save()
    }
}
