import Foundation

struct CoreDataContextProviding {
    let items: () throws -> [Stock]
    let isSaved: (Stock) throws -> (Bool)
    let save: (Stock) throws -> ()
    let delete: (Stock) throws -> ()
}

extension CoreDataContextProviding {
    static var live: Self {
        let context = PersistenceController.shared.container.viewContext
        return .init {
            let request = StockItem.fetchRequest()
            let items = try context.fetch(request)
            return items.compactMap { Stock(model: $0) }
        } isSaved: { stock in
            let request = StockItem.fetchRequest()
            let items = try context.fetch(request)
            return items.contains(where: { $0.symbol == stock.symbol })
        } save: { stock in
            let item = StockItem(context: context)
            item.name = stock.name
            item.symbol = stock.symbol
            item.logo = stock.logo?.absoluteString
            try context.save()
        } delete: { stock in
            let request = StockItem.fetchRequest()
            let items = try context.fetch(request)
            if let item = items.first(where: { $0.symbol == stock.symbol }) {
                context.delete(item)
                try context.save()
            }
        }
    }
}
