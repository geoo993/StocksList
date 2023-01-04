import Foundation

struct Stock: Equatable {
    let name: String
    let symbol: String
    let logo: URL?
    let price: Price?
}

extension Stock: Identifiable {
    var id: String { symbol }
}

extension Stock {
    init(stock: APIClient.Stock, price: APIClient.Price) {
        self.init(
            name: stock.name,
            symbol: stock.symbol,
            logo: .init(string: stock.logo),
            price: .init(model: price)
        )
    }
}

extension Stock {
    init?(model: StockItem) {
        guard
            let name = model.name,
            let symbol = model.symbol,
            let logo = model.logo
        else { return nil }
        self.init(
            name: name,
            symbol: symbol,
            logo: .init(string: logo),
            price: .none
        )
    }
}
